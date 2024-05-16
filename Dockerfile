# Use node image to build Angular app
FROM node:18 as build

WORKDIR /app

# Copy the Angular project files
COPY . .

# Install Angular CLI and dependencies, and build Angular app
RUN npm install -g @angular/cli && \
    npm install && \
    npm run build --prod

# Use an Ubuntu image for Puppet installation
FROM ubuntu:latest 

# Update package lists and install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Download and install Puppet
RUN wget https://apt.puppetlabs.com/puppet6-release-bionic.deb && \
    dpkg -i puppet6-release-bionic.deb && \
    apt-get update && \
    apt-get install -y puppet-agent && \
    apt-get clean

# Download Terraform
ARG TERRAFORM_VERSION="1.0.8"
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Set environment variables to ensure Puppet binaries are in the PATH
ENV PATH="/opt/puppetlabs/bin:${PATH}"

# Copy your Puppet file into the container
COPY sample.pp /sample.pp

# Copy built Angular app from the build stage
COPY --from=build /app/dist/pjt /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Run Puppet apply to execute your Puppet file
RUN puppet apply /sample.pp
RUN terraform init && terraform apply -auto-approve

# FROM node:18 as build

# WORKDIR /app
  
# COPY . .

# RUN npm install -g @angular/cli
# RUN npm install
# RUN npm run build --prod

# FROM nginx:alpine
  
# COPY --from=build app/dist/pjt /usr/share/nginx/html
  
# EXPOSE 80
# FROM ubuntu:latest 
# RUN apt-get update && \
#     apt-get install -y wget && \
#     apt-get clean

# # Download and install Puppet
# RUN wget https://apt.puppetlabs.com/puppet6-release-bionic.deb && \
#     dpkg -i puppet6-release-bionic.deb && \
#     apt-get update && \
#     apt-get install -y puppet-agent && \
#     apt-get clean
# ENV PATH="/opt/puppetlabs/bin:${PATH}"
# COPY sample.pp /sample.pp
# RUN puppet apply /sample.pp

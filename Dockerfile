
FROM node:18 as build
FROM ubuntu:latest 
WORKDIR /app
  
COPY . .

RUN npm install -g @angular/cli
RUN npm install
RUN npm run build --prod

FROM nginx:alpine
  
COPY --from=build app/dist/pjt /usr/share/nginx/html
  
EXPOSE 80

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Download and install Puppet
RUN wget https://apt.puppetlabs.com/puppet6-release-bionic.deb && \
    dpkg -i puppet6-release-bionic.deb && \
    apt-get update && \
    apt-get install -y puppet-agent && \
    apt-get clean
ENV PATH="/opt/puppetlabs/bin:${PATH}"
COPY sample.pp /sample.pp
RUN puppet apply /sample.pp

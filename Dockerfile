
FROM node:18 as build
  
WORKDIR /app
  
COPY . .

RUN npm install -g @angular/cli
RUN npm install
RUN npm run build --prod
FROM puppet/puppet-agent as puppet
FROM nginx:alpine
  
COPY --from=build app/dist/pjt /usr/share/nginx/html
  
EXPOSE 80
COPY --from=puppet /opt/puppetlabs/bin/puppet /usr/local/bin/puppet
RUN puppet apply sample.pp

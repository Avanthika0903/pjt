
FROM node:18 as build
  
WORKDIR /app
  
COPY . .

RUN npm install -g @angular/cli
RUN npm install
RUN npm run build --prod
  
FROM nginx:alpine
  
COPY --from=build src/app/dist/pjt /usr/share/nginx/html
  
EXPOSE 80

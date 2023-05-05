# ===========
# build stage
# ===========
FROM node:14.21.0 as build-stage

# make the 'app' folder the current working directory
WORKDIR /app

COPY package*.json ./

USER root

RUN npm install

COPY . /app/

RUN npm run build

# ================
# production stage
# ================
FROM nginx:1.14.2 as production-stage

USER root

COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx

RUN chown nginx /etc/nginx

EXPOSE 8443

USER root
CMD nginx -g 'daemon off;'

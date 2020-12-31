FROM node:lts-alpine as develop-stage
WORKDIR /app
RUN yarn global add @quasar/cli
RUN apk add --no-cache git pkgconfig autoconf automake libtool nasm build-base zlib-dev jpeg-dev
ENV LIBRARY_PATH=/lib:/usr/lib
COPY ./torre-insights ./
# build stage
FROM develop-stage as build-stage
RUN yarn
RUN quasar build
# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist/spa /usr/share/nginx/html
EXPOSE 80
COPY .docker/nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
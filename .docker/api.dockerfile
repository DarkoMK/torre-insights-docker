FROM composer:1.8.5 as build_stage

COPY ./torre-insights-backend /src
COPY ./.docker/run.sh /src
WORKDIR /src
RUN composer install

FROM alpine:3.8
RUN apk --no-cache add \
php7 \
php7-mbstring \
php7-session \
php7-openssl \
php7-tokenizer \
php7-json \
php7-pdo \
php7-pdo_mysql

COPY --from=build_stage /src  /src
RUN ls -al
RUN set -x \
addgroup -g 82 -S www-data \
adduser -u 82 -D -S -G www-data www-data

WORKDIR /src
RUN ls -al
RUN chmod -R 777 storage
RUN chmod +x run.sh
RUN cp run.sh /tmp
ENTRYPOINT ["/tmp/run.sh"]
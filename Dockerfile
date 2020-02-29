FROM alpine:latest AS build-stage
MAINTAINER jiezaizone
# create destination directory
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app
# install nodejs
RUN apk add --no-cache --update nodejs nodejs-npm git yarn
RUN git clone https://github.com/apache/incubator-apisix-dashboard.git
WORKDIR /usr/src/app/incubator-apisix-dashboard
RUN yarn install && yarn run build:prod

FROM nginx as production-stage
MAINTAINER jiezai
RUN mkdir /app
COPY --from=build-stage /usr/src/app/incubator-apisix-dashboard/dist /app
COPY nginx.conf /etc/nginx/nginx.conf
CMD ["nginx", "-g", "daemon off;"]

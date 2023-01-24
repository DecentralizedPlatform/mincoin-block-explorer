FROM node:10.19.0-alpine

RUN apk update && apk add git python make

WORKDIR /app

ADD package.json .
RUN npm install

ADD . .
ADD settings.json.template settings.json

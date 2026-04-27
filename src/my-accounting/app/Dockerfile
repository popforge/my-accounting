# syntax=docker/dockerfile:1
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN --mount=type=secret,id=npm_token \
    printf '@popforge:registry=https://npm.pkg.github.com\n//npm.pkg.github.com/:_authToken=%s\n' "$(cat /run/secrets/npm_token)" > .npmrc && \
    npm install
COPY . .
RUN npm run build

FROM nginx:alpine AS final
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

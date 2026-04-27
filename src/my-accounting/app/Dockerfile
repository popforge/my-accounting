# syntax=docker/dockerfile:1
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json .npmrc ./
RUN --mount=type=secret,id=npm_token \
    export NPM_TOKEN=$(cat /run/secrets/npm_token) && \
    npm install
COPY . .
RUN npm run build

FROM nginx:alpine AS final
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

# need to use the specific version of node that is dist is built 
FROM node:16.16.0 AS builder

WORKDIR /docker_osd_ws4

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx:latest

COPY --from=builder /docker_osd_ws4/dist/docker_osd_ws4 /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
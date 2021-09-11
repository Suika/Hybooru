FROM node:16.1.0
ENV DOCKERIZED=1

EXPOSE 80

WORKDIR /build
COPY . .
RUN npm install
RUN npm run build:prod

FROM node:16.1.0
ENV DOCKERIZED=1
WORKDIR /app

COPY --from=0 /build/dist /app
RUN npm install

CMD npm start

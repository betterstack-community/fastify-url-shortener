FROM node:20.16-alpine3.19 as dev

WORKDIR /build

COPY package*.json /build/

RUN npm ci && npm cache clean --force

COPY . /build/

EXPOSE 5000

CMD ["yarn", "run", "nodemon", "--legacy-watch", "--inspect=0.0.0.0:9229", "src/server.js"]





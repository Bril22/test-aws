# Stage 1
FROM --platform=linux/amd64 node:lts-alpine
FROM node:18 as builder

WORKDIR /build

COPY package*.json .
RUN npm install

COPY src/ src/
COPY tsconfig.json tsconfig.json

RUN npm run build



# Stage 2
FROM --platform=linux/amd64 node:lts-alpine
FROM node:18 as runner

WORKDIR /app

COPY --from=builder build/package*.json .
COPY --from=builder build/node_modules node_modules/
COPY --from=builder build/dist dist/

CMD [ "npm", "start" ]
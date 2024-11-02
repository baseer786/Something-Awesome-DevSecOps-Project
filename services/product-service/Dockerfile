FROM node:14-buster-slim

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY . .

EXPOSE 6001

USER node

CMD ["npm", "start"]

FROM node:latest
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY queryAPI.js /app/
CMD [ "node", "queryAPI.js" ]

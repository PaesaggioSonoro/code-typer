FROM node:20-bullseye

WORKDIR /app
COPY package*.json ./
COPY prisma ./prisma/

RUN apt-get update && apt-get install -y openssl python3 make g++ \
  && npm install \
  && npm install -g prisma

COPY . .

RUN npx prisma generate
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "start"]

FROM node:22

WORKDIR /app

COPY . .

# Force rebuild for correct platform
RUN npm rebuild @tailwindcss/oxide --force || true

RUN npm ci
RUN npm run build

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
EXPOSE 3000

CMD ["npm", "run", "start"]

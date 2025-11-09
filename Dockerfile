FROM node:22

WORKDIR /app

# Copy everything first (so prisma/ exists before npm ci)
COPY . .

# Install dependencies
RUN npm ci

# Build the Next.js app
RUN npm run build

# Environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

EXPOSE 3000

CMD ["npm", "run", "start"]

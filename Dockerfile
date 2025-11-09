# ---------- 1️⃣ Build stage ----------
FROM node:22 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Generate Prisma client and build Next.js
RUN npx prisma generate
RUN npm run build


# ---------- 2️⃣ Runtime stage ----------
FROM node:22 AS runner

WORKDIR /app

# Copy package files first
COPY package*.json ./

# Copy Prisma schema BEFORE installing deps so postinstall can run
COPY prisma ./prisma

# Install only production deps (runs postinstall, now schema exists)
RUN npm ci --omit=dev

# Copy build artifacts, public assets, Prisma client
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

# Optionally copy config files if present
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/package.json ./package.json

# Environment setup
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

EXPOSE 3000
CMD ["npm", "run", "start"]

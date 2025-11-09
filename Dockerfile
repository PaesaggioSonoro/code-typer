# ---------- 1️⃣ Build stage ----------
FROM node:22 AS builder

WORKDIR /app

# Copy package files first for dependency caching
COPY package*.json ./

# Install all dependencies (including dev) for build
RUN npm ci

# Copy source code
COPY . .

# Build Next.js app
RUN npm run build


# ---------- 2️⃣ Runtime stage ----------
FROM node:22 AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Copy only package files and production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built app and static assets from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/package.json ./package.json

# Expose the default Next.js port
EXPOSE 3000

# Start Next.js in production mode
CMD ["npm", "run", "start"]

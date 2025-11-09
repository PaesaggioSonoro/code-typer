# -- Build
FROM node:22 AS builder

WORKDIR /app

# Copy package files first for dependency caching
COPY package*.json ./

# Install dependencies (including dev deps for build)
RUN npm ci

# Copy rest of the source code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Build Next.js app
RUN npm run build

# -- Runtime
FROM node:22 AS runner

WORKDIR /app

# Only copy production deps
COPY package*.json ./
RUN npm ci --omit=dev

# Copy build artifacts and Prisma client from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

# Copy Next.js config, if present
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/package.json ./package.json

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Expose port 3000
EXPOSE 3000

# Default command: start the built Next.js app
CMD ["npm", "run", "start"]

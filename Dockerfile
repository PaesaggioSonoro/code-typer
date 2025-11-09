FROM node:22

# Create app directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of your project (includes prisma/, pages/, public/, etc.)
COPY . .

# Build the Next.js app
RUN npm run build

# Environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Expose the app port
EXPOSE 3000

# Default command
CMD ["npm", "run", "start"]

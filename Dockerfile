FROM node:22

WORKDIR /app

COPY . .

# Clean cache to ensure npm detects architecture correctly
RUN npm cache clean --force

# Install all dependencies
RUN npm ci

# Rebuild TailwindCSS oxide native module for this platform
RUN npm rebuild @tailwindcss/oxide --force || true

# Optional: Verify correct binary downloaded
RUN ls -1 node_modules/@tailwindcss/oxide-* || true

# Build Next.js app
RUN npm run build

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

EXPOSE 3000
CMD ["npm", "run", "start"]

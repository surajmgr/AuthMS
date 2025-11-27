# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

ARG PUBLIC_BETTER_AUTH_URL
ENV PUBLIC_BETTER_AUTH_URL=$PUBLIC_BETTER_AUTH_URL

ARG PUBLIC_GOOGLE_CLIENT_ID
ENV PUBLIC_GOOGLE_CLIENT_ID=$PUBLIC_GOOGLE_CLIENT_ID

ARG PUBLIC_CLOUDFLARE_TURNSTILE_SITE_KEY
ENV PUBLIC_CLOUDFLARE_TURNSTILE_SITE_KEY=$PUBLIC_CLOUDFLARE_TURNSTILE_SITE_KEY

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Prune development dependencies
RUN npm prune --production

# Run stage
FROM node:20-alpine

WORKDIR /app

# Copy built assets from builder stage
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV ORIGIN=http://localhost:3000

# Start the application
CMD ["node", "build"]

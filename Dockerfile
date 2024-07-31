# Use Node 20.16 alpine as base image
FROM node:20.16-alpine3.19 AS base

# Development stage
# =============================================================================
# Create a development stage based on the "base" image
FROM base AS development

# Change the working directory to /node
WORKDIR /node

# Copy the package.json and package-lock.json files to /node
COPY package*.json ./

# Install all dependencies and clean the cache
RUN npm ci && npm cache clean --force

# Change the working directory to /node/app
# This is where the project directory will be mounted to
WORKDIR /node/app

# Run the `dev` script for auto-reloading
CMD ["npm", "run", "dev"]

# Production stage
# =============================================================================
# Create a production stage based on the "base" image
FROM base AS production

# Change the working directory to /build
WORKDIR /build

# Copy the package.json and package-lock.json files to the /build directory
COPY package*.json ./

# Install production dependencies and clean the cache
RUN npm ci --omit=dev  && npm cache clean --force

# Copy the entire source code into the container
COPY . .

# Document the port that may need to be published
EXPOSE 5000

# Start the application
CMD ["node", "src/server.js"]

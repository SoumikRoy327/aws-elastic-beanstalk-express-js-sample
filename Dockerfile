# Node 16 is used to align with the assessment requirement
FROM node:16-alpine

# Application directory inside the container
WORKDIR /usr/src/app

# Copy dependency files first
COPY package*.json ./

# Install production dependencies
RUN npm ci --omit=dev

# Copy application source
COPY app.js ./

# Application listens on port 8080 inside the container
EXPOSE 8080

# Run as the non-root Node user
USER node

# Start the application
CMD ["npm", "start"]

# Use official Node.js image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy app code
COPY . .

# Expose app port (change if needed)
EXPOSE 3000

# Start app
CMD ["node", "app.js"]

# Build phase
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and lock file
COPY package.json package-lock.json ./ 

# Install dependencies
RUN yarn install

# Copy all files
COPY . .

# Build the app
RUN yarn build

# Production phase
FROM nginx:alpine

# Copy the React build from the build phase
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

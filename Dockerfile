# Stage 1: Build the React application
FROM node:24-alpine AS build

# 1. Set the working directory first
WORKDIR /app

# 2. Copy dependency files and install (Optimizes Docker cache)
COPY package*.json ./
RUN npm install

# 3. Declare the Build Argument 
# This must be defined AFTER 'FROM' to be accessible in this stage
ARG REACT_APP_BACKEND_URL
# Set it as an ENV so the 'npm run build' process can see it
ENV REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL

# 4. Copy the rest of the application code
COPY . .

# 5. Build the application
# Since the ENV is already set, npm run build will pick it up automatically
RUN npm run build

# Stage 2: Serve the React application with Nginx
FROM nginx:alpine

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static files from the build stage
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
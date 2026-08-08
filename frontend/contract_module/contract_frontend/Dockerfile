# Stage 1: Build the Flutter web application
FROM ghcr.io/cirruslabs/flutter:3.32.0 AS build

WORKDIR /app
COPY . .

# Fetch dependencies
RUN flutter pub get

# Build for web
RUN flutter build web --release --no-tree-shake-icons

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

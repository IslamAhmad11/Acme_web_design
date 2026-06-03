# Use lightweight alpine image
FROM nginx:alpine

# Update internal alpine packages to patch base image vulnerabilities (like CVE-2026-6732)
RUN apk update && apk upgrade --no-cache

# Create a non-root user and group for security hardening
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only the needed static files (relies on .dockerignore to exclude .git, terraform, etc.)
COPY . /usr/share/nginx/html

# Set correct ownership for the non-root user to access required directories
RUN chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /var/run

# Switch execution context to the non-root user
USER appuser

# Health check to periodically verify nginx is running and serving traffic
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -q --spider http://localhost:80 || exit 1

# Document that the container listens on port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

# Use a specific lightweight Nginx image for reproducible builds
FROM nginx:1.29-alpine

# Image metadata
LABEL maintainer="Islam Ahmad"
LABEL description="Static website deployed using Docker, Kubernetes, Terraform, and Google Cloud Platform"
LABEL version="1.0"

# Update Alpine packages to patch known vulnerabilities
RUN apk update && apk upgrade --no-cache

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy website files into the Nginx web root
COPY . /usr/share/nginx/html

# Set correct ownership
RUN chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /var/run

# Run the container as a non-root user
USER appuser

# Verify that Nginx is serving traffic
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD wget -q --spider http://localhost:80 || exit 1

# Document the listening port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

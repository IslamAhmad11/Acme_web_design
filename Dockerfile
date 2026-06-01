# Use lightweight alpine image
FROM nginx:alpine

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only the needed static files (exclude .git, k8s, terraform, etc. via .dockerignore)
COPY . /usr/share/nginx/html

# Set correct ownership
RUN chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /var/run

# Run as non-root user
USER appuser

# Health check to verify nginx is serving
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -q --spider http://localhost:80 || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

FROM nginx:1.29-alpine

LABEL maintainer="Islam Ahmad"
LABEL description="Static website deployed using Docker, Kubernetes, Terraform and GKE"
LABEL version="1.2"

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN rm -rf /usr/share/nginx/html/*

COPY . /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p \
    /tmp/client_temp \
    /tmp/proxy_temp \
    /tmp/fastcgi_temp \
    /tmp/uwsgi_temp \
    /tmp/scgi_temp \
 && chown -R appuser:appgroup /usr/share/nginx/html /tmp

USER appuser

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
CMD wget -q --spider http://localhost || exit 1

EXPOSE 80

CMD ["nginx","-g","pid /tmp/nginx.pid; daemon off;"]

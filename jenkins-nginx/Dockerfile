FROM alpine:3.4 
MAINTAINER tomwillfixit 

# Install NGINX

RUN apk add --update curl bash nginx && rm -rf /var/cache/apk/*

# Add default configuration
COPY conf/jenkins.conf /etc/nginx/conf.d/jenkins.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
      CMD curl -f http://localhost:80 || exit 1

CMD ["nginx"]

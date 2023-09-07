from ubuntu:latest
RUN apt-get -y update && apt-get -y install nginx

COPY default /etc/nginx/sites-available/default 
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

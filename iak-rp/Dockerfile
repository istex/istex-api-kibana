# use the ngnix server to serve the built stuff
FROM nginx:1.13.7-perl

# vim & curl : for debug
# apache2-utils: for creating credentials
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y install vim curl apache2-utils

# nginx config
COPY ./nginx.prod.conf /etc/nginx/nginx.conf
COPY ./entrypoint-create-credentials /bin/entrypoint-create-credentials

CMD /bin/entrypoint-create-credentials ; nginx -g 'daemon off;'
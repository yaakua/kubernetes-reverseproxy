#
# Reverse proxy for kubernetes
#
FROM index.tenxcloud.com/docker_library/nginx:latest

ENV DEBIAN_FRONTEND noninteractive

# Prepare requirements 
RUN apt-get update -qy && \
    apt-get install --no-install-recommends -qy software-properties-common

# setup confd
COPY confd-0.11.0-linux-amd64 /usr/local/bin/confd
RUN chmod u+x /usr/local/bin/confd && \
	mkdir -p /etc/confd/conf.d && \
	mkdir -p /etc/confd/templates

ADD ./src/confd/conf.d/myconfig.toml /etc/confd/conf.d/myconfig.toml
ADD ./src/confd/templates/nginx.tmpl /etc/confd/templates/nginx.tmpl
ADD ./src/confd/confd.toml /etc/confd/confd.toml

ADD ./src/boot.sh /opt/boot.sh
RUN chmod +x /opt/boot.sh

EXPOSE 80 443 3306

# Run the boot script
CMD /opt/boot.sh

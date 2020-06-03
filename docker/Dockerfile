# 
# Dockerfile for ceur-ws.org replica 
# see https://github.com/ceurws/lod/issues/16
#
FROM ubuntu:18.04

LABEL maintainer="wf@bitplan.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    # Install apache
    apache2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# prepare and enable https://httpd.apache.org/docs/2.4/mod/mod_ext_filter.html
# special filter to "fix links"
COPY filter.conf /etc/apache2/conf-available
COPY --chown=www-data:www-data filter.awk /var/www/filter.awk 
# enable filter module and use configuration
RUN a2enmod ext_filter&&a2enconf filter

EXPOSE 80 443

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

CMD apachectl -D FOREGROUND 

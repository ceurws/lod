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

EXPOSE 80 443

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

CMD apachectl -D FOREGROUND 

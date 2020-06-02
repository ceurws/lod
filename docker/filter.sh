#!/bin/bash
# WF 2020-06-02
# filter all html output thru this script
port=8880
host=capri
# substitute all hard links in CEUR-WS with a local link
/bin/sed s#http://ceur.ws.org#http://$host:$port#g
# try out this filter with
# cat /var/www/html/index.html | /root/bin/filter.sh | grep capri

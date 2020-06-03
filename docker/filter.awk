#!/usr/bin/awk
# WF 2020-06-03
#
# filter HTML output thru this awk script to fix global links to local ones
#
# you might want to try out this filter from the command line with
# cat /var/www/html/index.html | awk -f filter.awk 
#
# setup the  replacement
BEGIN {
  port=8880
  host="capri"
  sourceServer="http://ceur-ws.org" 
  targetServer=sprintf("http://%s:%s",host,port) 
  sourceFtp="http://sunsite.informatik.rwth-aachen.de/ftp/pub/publications/CEUR-WS"
  targetFtp=sprintf("%s/ftp",targetServer)
}
# for each line in the HTML source
{
  # get the line
  line=$0
  # replace any sourceServer reference with the targetServer reference
  gsub(sourceServer,targetServer,line)
  # replace any sourceFtp reference with the targetFtp reference
  gsub(sourceFtp,targetFtp,line)
  # output the modified line
  print line 
}

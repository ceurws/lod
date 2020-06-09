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
  sourceServer="http://ceur-ws.org" 
  scheme=ENVIRON["REQUEST_SCHEME"] # e.g. http
  uri=ENVIRON["DOCUMENT_URI"] # e.g. index.html
  host=ENVIRON["HTTP_HOST"]  # e.g. capri:8880
  targetServer=sprintf("%s://%s",scheme,host)  # e.g http://capri:8080
  sourceFtp="http://sunsite.informatik.rwth-aachen.de/ftp"
  targetFtp=sprintf("%s/ftp",targetServer)
  # content negotiation
  filter=1
  if ("HTTP_ACCEPT" in ENVIRON) {
    accept=ENVIRON["HTTP_ACCEPT"]
    proceedings=sprintf("%s%s",sourceServer,uri)
    gsub("/index.html","",proceedings)
    if (accept=="application/rdf+xml") {
      filter=0
      print "<rdf:RDF xmlns='http://swrc.ontoware.org/ontology#'"
      print "  xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>"
      printf (" <InProceedings rdf:about='%s'>\n",proceedings)
      print "    <rdf:type rdf:resource='http://xmlns.com/foaf/0.1/Document'/>"
      print "  </InProceedings>"
      print "</rdf:RDF>"
    } else if (accept=="application/json") {
      filter=0
      blank="    "
      json=sprintf("{\n%s'proceedings': {\n%s%s'url': '%s'\n%s}\n}\n",blank,blank,blank,proceedings,blank)
      gsub("'","\"",json)
      print json
    }
  } else {
    filter=1
  }
}
# for each line in the HTML source
# HTML 
/<(HTML|html)>/ && filter {
  printf("<!-- this page has been filtered for host %s port %d -->\n",host,port)
  # debugging information - comment out if you'd like to test new environment
  # variable based features
  for (e in ENVIRON)
    printf("<!-- %s=%s -->\n",e,ENVIRON[e])
  print $0
  next
}
filter {
  # get the line
  line=$0
  # replace any sourceServer reference with the targetServer reference
  gsub(sourceServer,targetServer,line)
  # replace any sourceFtp reference with the targetFtp reference
  gsub(sourceFtp,targetFtp,line)
  # output the modified line
  print line 
}

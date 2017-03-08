FROM ubuntu:trusty

MAINTAINER Hannes und Christian @ Digifors GmbH

#install Java, vim, wget
RUN  apt-get update
RUN  apt-get -y install default-jre vim wget nmap curl unzip

#install Elasticsearch
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch |  apt-key add -
RUN echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" |  tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
RUN  apt-get update
RUN  apt-get -y install elasticsearch
ADD conf/elasticsearch.yml /etc/elasticsearch
RUN  service elasticsearch restart
RUN  update-rc.d elasticsearch defaults 95 10

#install Kibana
RUN echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" |  tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
RUN  apt-get update
RUN  apt-get -y install kibana
ADD  conf/kibana.yml /opt/kibana/config
RUN  update-rc.d kibana defaults 96 9
RUN  service kibana start

#install Nginx
RUN  apt-get -y install nginx apache2-utils
ADD  conf/htpasswd.users /etc/nginx/htpasswd.users
ADD  conf/default  /etc/nginx/sites-available
RUN  service nginx restart

#create SSL certificates
RUN  mkdir -p /etc/pki/tls/certs
RUN  mkdir /etc/pki/tls/private
ADD  conf/openssl.cnf /etc/ssl
RUN  openssl req -config /etc/ssl/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key -out /etc/pki/tls/certs/logstash-forwarder.crt

#install Logstash
RUN echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' |  tee /etc/apt/sources.list.d/logstash-2.2.x.list
RUN  apt-get update
RUN  apt-get -y install logstash
RUN  /opt/logstash/bin/plugin install logstash-codec-nmap
 
#configure Logstash
ADD  conf/my_config2 /etc/logstash/conf.d
RUN  service logstash configtest
RUN  service logstash restart
RUN  update-rc.d logstash defaults 96 9

ADD conf/elasticsearch_mapping.json /opt/logstash/
ADD conf/bash.bashrc /etc
CMD -p 80:80 -p 8000:8000

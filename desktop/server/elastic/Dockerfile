FROM almalinux:10.0-minimal

# installation of filebeat
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN <<EOF
cat <<- CATEOF > /etc/yum.repos.d/elastic.repo
[elasticsearch]
name=Elastic repository for 9.x packages
baseurl=https://artifacts.elastic.co/packages/9.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
CATEOF
EOF

RUN microdnf install -y --enablerepo=elasticsearch shadow-utils elasticsearch

USER elasticsearch
ENV ES_HOME=/usr/share/elasticsearch
ENV ES_PATH_CONF=/etc/elasticsearch
ENV PID_DIR=/var/run/elasticsearch
ENV ES_SD_NOTIFY=true

#COPY --chown=logstash:logstash config/ /home/logstash/config/

# # command
# ENTRYPOINT ["/usr/share/logstash/bin/logstash"]
# CMD ["--path.settings", "/home/logstash/config"]

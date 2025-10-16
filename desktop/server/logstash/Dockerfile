FROM almalinux:10.0-minimal

# installation of filebeat
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN <<EOF
cat <<- CATEOF > /etc/yum.repos.d/elastic.repo
[logstash-9.x]
name=Elastic repository for 9.x packages
baseurl=https://artifacts.elastic.co/packages/9.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
CATEOF
EOF

RUN <<EOF
    echo "logstash:x:1000:1000:logstash user:/home/logstash:/bin/bash" >> /etc/passwd
    echo "logstash:x:1000:" >> /etc/group
    mkdir -p /home/logstash/{log,config,data}
    chown -R logstash:logstash /home/logstash
    microdnf install -y logstash
EOF

# copy config
COPY --chown=logstash:logstash config/ /home/logstash/config/

USER logstash
ENV LS_HOME="/usr/share/logstash"
ENV LS_SETTINGS_DIR="/home/logstash/config"
ENV LS_PIDFILE="/var/run/logstash.pid"
ENV LS_USER="logstash"
ENV LS_GROUP="logstash"
ENV LS_GC_LOG_FILE="/home/logstash/log/gc.log"
ENV LS_OPEN_FILES="16384"
ENV LS_NICE="19"
ENV SERVICE_NAME="logstash"
ENV SERVICE_DESCRIPTION="logstash"


# command
ENTRYPOINT ["/usr/share/logstash/bin/logstash"]
CMD ["--path.settings", "/home/logstash/config"]

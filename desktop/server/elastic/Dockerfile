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

RUN rm -fr /etc/elasticsearch
COPY --chown=root:elasticsearch config/ /etc/elasticsearch
RUN <<EOF
    mkdir -p /var/run/elasticsearch
    chown elasticsearch:elasticsearch /var/run/elasticsearch
    chmod 660 /etc/elasticsearch/*.yml /etc/elasticsearch/*.keystore /etc/elasticsearch/users /etc/elasticsearch/users_roles
EOF

USER elasticsearch
ENV ES_HOME=/usr/share/elasticsearch
ENV ES_PATH_CONF=/etc/elasticsearch
ENV PID_DIR=/var/run/elasticsearch
ENV ES_SD_NOTIFY=true

# command
ENTRYPOINT ["/usr/share/elasticsearch/bin/elasticsearch"]
CMD ["-p", "/var/run/elasticsearch/elastic.pid"]

FROM almalinux:10.0-minimal

# installation of filebeat
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN <<EOF
cat <<- CATEOF > /etc/yum.repos.d/elastic.repo
[elastic-9.x]
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
    microdnf install -y filebeat
    echo "filebeat:x:1000:1000:filebeat user:/home/filebeat:/bin/bash" >> /etc/passwd
    echo "filebeat:x:1000:" >> /etc/group
    mkdir -p /home/filebeat/{config,data,log}
    mkdir /home/filebeat/config/inputs.d
    cp -r /etc/filebeat/modules.d /home/filebeat/config/
    chown -R filebeat:filebeat /home/filebeat
EOF

# copy config
COPY --chown=filebeat:filebeat main.yml /home/filebeat/config/
COPY --chown=filebeat:filebeat inputs.d /home/filebeat/config/inputs.d/
RUN find /home/filebeat/config -type f -exec chmod 544 {} +
USER filebeat

# command
ENTRYPOINT ["/usr/share/filebeat/bin/filebeat"]
CMD ["--environment", "container", "-c", "/home/filebeat/config/main.yml", "--path.home", "/usr/share/filebeat", "--path.config", "/home/filebeat/config", "--path.data", "/home/filebeat/data", "--path.logs", "/home/filebeat/log"]

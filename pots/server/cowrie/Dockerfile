FROM alpine:3.22.1 as builder

# Install packages
RUN apk update && apk add git python3 py3-pip py3-virtualenv libssl3 libffi make build-base bash

# Add cowrie user & su user
RUN adduser --disabled-password cowrie
USER cowrie
WORKDIR /home/cowrie

# build
RUN git clone http://github.com/cowrie/cowrie cowrie
WORKDIR /home/cowrie/cowrie
RUN python -m venv cowrie-env && . cowrie-env/bin/activate && \
    python -m pip install --upgrade pip && \
    python -m pip install --upgrade -r requirements.txt && \
    python -m pip install -e .


# make runtime image
FROM alpine:3.22.1 as runtime

# copy files from builder and local
COPY --from=builder --chown=root:root /etc/passwd /etc/group /etc/
COPY --from=builder --chown=cowrie:cowrie /home /home
COPY --chown=cowrie:cowrie cowrie.cfg /home/cowrie/cowrie/etc/

RUN apk update && apk add python3

# change user
USER cowrie
WORKDIR /home/cowrie/cowrie

ENTRYPOINT ["/home/cowrie/cowrie/cowrie-env/bin/twistd"]
CMD ["-n", "--umask=0022", "--pidfile=", "cowrie"]

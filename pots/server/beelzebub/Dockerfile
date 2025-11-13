FROM alpine:3.22.1 AS builder

RUN apk update && apk add go
RUN wget https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.5.0.tar.gz 
RUN mkdir -p /beelzebub
RUN tar xfz v3.5.0.tar.gz -C beelzebub --strip-components 1

WORKDIR /beelzebub
RUN go mod download && \
    go build -o main .


FROM alpine:3.22.1 AS runtime

RUN adduser --disabled-password beelzebub
COPY --from=builder --chown=beelzebub:beelzebub /beelzebub/main /home/beelzebub/
RUN mkdir -p /home/beelzebub/log

USER beelzebub
WORKDIR /home/beelzebub
ENTRYPOINT ["/home/beelzebub/main"]

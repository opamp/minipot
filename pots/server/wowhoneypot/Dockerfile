FROM alpine:3.22.1

ENV TZ=Asia/Tokyo

RUN apt update && apk add git python3 && adduser -D takashi
USER takashi
WORKDIR /home/takashi
RUN git clone https://github.com/opamp/WOWHoneypot.git wowhoneypot
WORKDIR /home/takashi/wowhoneypot

CMD ["python3", "./wowhoneypot.py"]


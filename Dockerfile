FROM amd64/ubuntu:jammy

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN mkdir -p /root/bsky-feed

ADD supervisor/*.conf /etc/supervisor/conf.d/

WORKDIR /root/bsky-feed

RUN apt update
RUN apt install -y python3-pip nginx supervisor curl
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs
RUN npm install --global yarn
WORKDIR /root/bsky-feed
RUN yarn

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["/usr/bin/supervisord", "-n"]

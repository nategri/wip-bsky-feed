FROM amd64/ubuntu:jammy

RUN mkdir -p /root/bsky-feed

ADD supervisor/*.conf /etc/supervisor/conf.d/

WORKDIR /root/bsky-feed

RUN apt update
RUN apt install -y python3-pip nginx supervisor

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80/tcp
EXPOSE 443/tcp

RUN nginx

#CMD ["gunicorn", "--workers", "1", "--bind", "unix:bskyfeed.sock", "wsgi:app"]
CMD ["/usr/bin/supervisord", "-n"]
#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

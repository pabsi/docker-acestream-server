FROM python:2.7.17-slim-buster

RUN adduser --disabled-password --shell /sbin/nologin --gecos 'AceStream Engine User' --quiet acestream
WORKDIR /home/acestream
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
	net-tools pkg-config wget \
	gcc-7 gcc make libxslt1.1 \
	python-dev libpython2.7 python-setuptools python-m2crypto python-apsw libxslt1.1 \
	&& apt-get clean -qq && rm -rf /root/.cache/* /tmp/* /var/lib/apt /var/cache/apt

RUN pip install --upgrade --no-cache-dir pip
RUN pip install --upgrade --no-cache-dir wheel==0.35.1 Cython==0.25.2 apsw==3.9.2-r1 requests

RUN wget --no-check-certificate -q https://download.acestream.media/linux/acestream_3.1.74_debian_10.5_x86_64.tar.gz -O as.tar.gz \
	&& tar xf as.tar.gz && rm as.tar.gz

RUN rm -rf /root/.cache/* /tmp/* /var/lib/apt /var/cache/apt

RUN pip install --upgrade --no-cache-dir pycryptodome rdflib

USER acestream
RUN mkdir -p /home/acestream/.ACEStream/logs

EXPOSE 6878/tcp

HEALTHCHECK --interval=1s --timeout=5s \
	CMD netstat -tlpn | grep 6878 | grep -q LISTEN

CMD ["/home/acestream/start-engine", "--download-limit", "0", "--client-console", "--log-stdout", "--log-stdout-level", "info"]

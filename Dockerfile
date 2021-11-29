FROM debian:9-slim

RUN adduser --disabled-password --shell /sbin/nologin --gecos '' --quiet acestream
WORKDIR /home/acestream

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
	net-tools=1.60+git20161116.90da8a0-1 pkg-config=0.29-4+b1 wget=1.18-5+deb9u3 \
	python=2.7.13-2 python-dev=2.7.13-2 libpython2.7=2.7.13-2+deb9u5 \
	python-pip=9.0.1-2+deb9u2 python-m2crypto=0.24.0-1.1 python-setuptools=33.1.1-1 \
	gcc-6=6.3.0-18+deb9u1 gcc=4:6.3.0-4 make=4.1-9.1 libxslt1.1=1.1.29-2.1+deb9u2 \
	&& apt-get clean -qq && rm -rf /root/.cache/* /tmp/* /var/lib/apt /var/cache/apt

RUN pip install --no-cache-dir wheel==0.35.1 Cython==0.25.2 apsw==3.9.2-r1 pysegment

RUN wget -q https://download.acestream.media/linux/acestream_3.1.49_debian_9.9_x86_64.tar.gz -O as.tar.gz \
	&& tar xf as.tar.gz && rm as.tar.gz

RUN apt-get remove --purge -yqq \
	pkg-config wget gcc make binutils ca-certificates cpp gcc-6 libasan3 libatomic1 \
	libcilkrts5 libgcc-6-dev libglib2.0-0 libgomp1 libidn11 libisl15 python-urllib3 \
	libitm1 liblsan0 libmpc3 libmpfr4 libpsl5 libquadmath0 libtsan0 libubsan0 openssl \
	perl perl-modules-5.24 libperl5.24 libdpkg-perl libc6-dev \
	&& rm -rf /root/.cache/* /tmp/* /var/lib/apt /var/cache/apt

USER acestream

EXPOSE 6878/tcp

HEALTHCHECK --interval=1s --timeout=5s \
	CMD netstat -tlpn | grep 6878 | grep -q LISTEN

CMD ["/home/acestream/start-engine", "--download-limit", "0", "--client-console", "--log-stdout", "--log-stdout-level", "info"]

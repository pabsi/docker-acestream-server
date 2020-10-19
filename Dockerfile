FROM debian:9-slim

RUN adduser --disabled-password --shell /sbin/nologin --gecos '' --quiet acestream
WORKDIR /home/acestream

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
	net-tools pkg-config wget python python-dev libpython2.7 python-pip \
	python-m2crypto python-setuptools gcc make libxslt1.1 \
	&& apt-get clean -qq && rm -rf /root/.cache/* /tmp/* /var/lib/apt /var/cache/apt

RUN pip install --no-cache-dir wheel Cython==0.25.2 apsw

RUN wget -q http://download.acestream.media/linux/acestream_3.1.49_debian_9.9_x86_64.tar.gz -O as.tar.gz \
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

CMD ["/acestream/start-engine", "--download-limit", "0", "--client-console", "2>/dev/null"]

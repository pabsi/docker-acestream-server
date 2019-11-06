FROM debian:8-slim

RUN apt-get update -qq && apt-get install --no-install-recommends -yqq \
	net-tools pkg-config wget python python-dev libpython2.7 python-pip \
	python-m2crypto python-setuptools gcc make libxslt1.1 \
	&& apt-get clean -qq

RUN pip install --quiet --download-cache /tmp/ wheel Cython==0.25.2 apsw

RUN mkdir /acestream \
	&& wget -q http://acestream.org/downloads/linux/acestream_3.1.49_debian_8.11_x86_64.tar.gz -O as.tar.gz \
	&& tar xf as.tar.gz -C /acestream && rm as.tar.gz

RUN apt-get remove --purge -yqq --force-yes \
	pkg-config wget	gcc make binutils ca-certificates cpp cpp-4.9 gcc-4.9 libasan1 libatomic1 \
	libcilkrts5 libcloog-isl4 libgcc-4.9-dev libglib2.0-0 libgomp1 libicu52 libidn11 libisl10 \
	libitm1 liblsan0 libmpc3 libmpfr4 libpsl0 libquadmath0 libtsan0 libubsan0 openssl python-chardet \
	python-colorama python-distlib python-html5lib python-requests python-six \
	python-urllib3 && rm -rf /root/.cache/* /tmp/* /var/lib/apt /var/cache/apt

EXPOSE 6878/tcp

HEALTHCHECK --interval=1s --timeout=5s \
	CMD netstat -tlpn | grep 6878 | grep -q LISTEN

CMD ["/acestream/start-engine", "--client-console", "2>/dev/null"]

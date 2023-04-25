FROM php:5.4.45-cli
ENV CC=gcc
ENV CFLAGS="-g -O2 -std=gnu99"
WORKDIR /usr/src/
COPY php.ini /usr/local/etc/php/
COPY ZendGuardLoader.so .
COPY Zend-Decoder /usr/src/Zend-Decoder
RUN echo "deb http://archive.debian.org/debian wheezy main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian wheezy main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security wheezy/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian-security wheezy/updates main contrib non-free" >> /etc/apt/sources.list && \
    # APT BACKPORTS
    echo "deb http://archive.debian.org/debian wheezy-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian wheezy-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian wheezy-backports-sloppy main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian wheezy-backports-sloppy main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --force-yes git patch
RUN git clone https://github.com/lighttpd/xcache
RUN cd xcache && \
    patch -p1 < ../Zend-Decoder/xcache.patch && \
    phpize && \
    ./configure --enable-xcache-disassembler && \
    make

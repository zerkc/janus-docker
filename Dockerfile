FROM ubuntu:20.04

#Actualicazion
RUN apt update
RUN apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

#Librerias necesario y complementos
RUN apt install -y libmicrohttpd-dev libjansson-dev \
	libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
	libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
	libconfig-dev pkg-config gengetopt libtool automake meson golang \
	libnanomsg-dev libnice-dev git openssh-server sudo libssl-dev libjson-c-dev \
	libwebsockets-dev vim-common pkg-config g++ cmake emacs nano tmux

RUN wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz \
&& tar xfv v2.2.0.tar.gz \
&& cd libsrtp-2.2.0 \
&& ./configure --prefix=/usr --enable-openssl \
&& make shared_library && sudo make install

RUN git clone https://gitlab.freedesktop.org/libnice/libnice \
&& cd libnice \
&& meson --prefix=/usr build \
&& ninja -C build \
&& sudo ninja -C build install

RUN git clone https://boringssl.googlesource.com/boringssl \
&& cd boringssl \
&& sed -i s/" -Werror"//g CMakeLists.txt \
&& mkdir -p build \
&& cd build \
&& cmake -DCMAKE_CXX_FLAGS="-lrt" .. \
&& make \
&& cd .. \
&& sudo mkdir -p /opt/boringssl \
&& sudo cp -R include /opt/boringssl/ \
&& sudo mkdir -p /opt/boringssl/lib \
&& sudo cp build/ssl/libssl.a /opt/boringssl/lib/ \
&& sudo cp build/ssl/libssl.a /opt/boringssl/lib/

RUN git clone https://github.com/sctplab/usrsctp \
&& cd usrsctp \
&& ./bootstrap \
&&  ./configure --libdir=/usr/lib64 --prefix=/usr  --disable-programs --disable-inet --disable-inet6 \
&& make && sudo make install

RUN git clone https://libwebsockets.org/repo/libwebsockets \
&& cd libwebsockets \
&& git checkout v3.2-stable \
&& mkdir build \
&& cd build \
&& cmake -DLWS_MAX_SMP=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. \
&& make && sudo make install

RUN git clone https://github.com/eclipse/paho.mqtt.c.git \
&& cd paho.mqtt.c \
&& make && sudo make install

RUN git clone https://github.com/alanxz/rabbitmq-c \
&& cd rabbitmq-c \
&& git submodule init \
&& git submodule update \
&& mkdir build && cd build \
&& cmake --libdir=/usr/lib64 -DCMAKE_INSTALL_PREFIX=/usr .. \
&& make && sudo make install

RUN git clone https://github.com/meetecho/janus-gateway.git \
&& cd janus-gateway \
&& sh autogen.sh \
&& ./configure --prefix=/opt/janus \
&& make \
&& make install










CMD ./start.sh

# BSD 2-Clause License

# Copyright (c) 2020-2025, Supreeth Herle
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && \
    apt-get -y install wget gnupg

# Install more dependencies
RUN apt-get update && \
    apt-get -y install telnet iproute2 net-tools git pkg-config autoconf make libtool gettext gperf libgmp-dev bison flex automake autotools-dev rebar3 libpcap-dev nftables tcpdump

# Compile epdg
RUN git clone https://github.com/aseaudi/epdg && \
    cd epdg && \
    git checkout epdg4 && \
    autoreconf -i && \
    ./configure \
        --sysconfdir=/etc \
        --enable-eap-aka \
        --enable-eap-aka-3gpp \
        --enable-eap-aka-3gpp2 \
        --enable-eap-simaka-reauth \
        --enable-save-keys \
        --enable-p-cscf \
        --enable-epdg \
        --enable-swanctl --enable-vici --enable-charon --disable-systemd

RUN cd epdg && \
    make -j`nproc` && make install

RUN rm -rf epdg

RUN apt install -y git build-essential autoconf automake libtool pkg-config libmnl-dev && \
    git clone https://gitea.osmocom.org/cellular-infrastructure/libgtpnl && \
    cd libgtpnl && \ 
    autoreconf -fi && \
    ./configure && \
    make && make install && \
    ldconfig 

CMD ["/mnt/epdg/epdg_init.sh"]

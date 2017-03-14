FROM bwstitt/ubuntu:16.04

# TODO: software-properties-common is really heavy just to add a ppa...
RUN docker-apt-install software-properties-common

# install the PPA
ARG bitcoin_ppa=bitcoin/bitcoin
RUN add-apt-repository ppa:${bitcoin_ppa}

# install the bitcoind package (and wget for alert scripts)
ARG bitcoin_package=bitcoind
RUN docker-apt-install \
    ${bitcoin_package} \
    wget

# use the abc user that comes with the image
USER abc
ENV HOME=/home/abc
ENV PATH="${PATH}:/home/abc/bin"
WORKDIR /home/abc

# setup volume for the config and data
RUN mkdir ~/.bitcoin
VOLUME /home/abc/.bitcoin

# run the daemon by default
CMD bitcoind -printtoconsole

HEALTHCHECK --interval=5m --timeout=3s \
    CMD bitcoin-cli getinfo || exit 1

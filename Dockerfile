#
# Quick and easy bitcoin node
#
# todo: template this to support multiple bitcoin implementations
#

FROM bwstitt/library-ubuntu:16.04

ENV bitcoin_ppa bitcoin-unlimited/bu-ppa
ENV bitcoin_package bitcoind
ENV bitcoin_label bitcoinunlimited

# todo: software-properties-common is really heavy just to add a ppa...
RUN docker-apt-install software-properties-common

# install the PPA
RUN add-apt-repository ppa:${bitcoin_ppa}

# install bitcoin (and wget for alert scripts)
RUN docker-apt-install \
    ${bitcoin_package} \
    wget

# create user
RUN useradd -ms /bin/bash bitcoin
USER bitcoin
ENV HOME=/home/bitcoin
ENV PATH="${PATH}:/home/bitcoin/bin"

ADD bitcoin.conf /home/bitcoin/.bitcoin/bitcoin.conf
USER root
RUN chown -R bitcoin:bitcoin /home/bitcoin/.bitcoin
USER bitcoin

VOLUME /home/bitcoin/.bitcoin

# run the daemon by default
WORKDIR /home/bitcoin
ENTRYPOINT bitcoind
CMD -printtoconsole

EXPOSE 8332
EXPOSE 8333

# Rockerfiles have this, but don't work with Docker Hub
# ATTACH /bin/bash -l
# PUSH bwstitt/bitcoin:{{ $bitcoin_label }}

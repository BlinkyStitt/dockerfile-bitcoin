#
# Quick and easy bitcoin node
#
# todo: template this to support multiple bitcoin implementations
#

FROM bwstitt/library-ubuntu:16.04

# todo: software-properties-common is really heavy just to add a ppa...
RUN docker-apt-install software-properties-common

# install the PPA
ARG bitcoin_ppa=bitcoin-unlimited/bu-ppa
RUN add-apt-repository ppa:${bitcoin_ppa}

# install the bitcoind package (and wget for alert scripts)
ARG bitcoin_package=bitcoind
RUN docker-apt-install \
    ${bitcoin_package} \
    wget

# create user
RUN useradd -ms /bin/bash bitcoin
USER bitcoin
ENV HOME=/home/bitcoin
ENV PATH="${PATH}:/home/bitcoin/bin"

# setup bare-bones config
ADD bitcoin.conf /home/bitcoin/.bitcoin/bitcoin.conf
# TODO: I wish ADD kept the USER
USER root
RUN chown -R bitcoin:bitcoin /home/bitcoin/.bitcoin
USER bitcoin

VOLUME /home/bitcoin/.bitcoin

# run the daemon by default
WORKDIR /home/bitcoin
CMD bitcoind -printtoconsole

# EXPOSE 8332
EXPOSE 8333

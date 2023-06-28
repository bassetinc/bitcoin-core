FROM ubuntu:latest AS prep

ENV BITCOIN_VERSION 0.20.0

WORKDIR /app

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates gnupg wget && \
    export GNUPGHOME="$(mktemp -d)" && \
    wget "https://bitcoin.org/bin/bitcoin-core-$BITCOIN_VERSION/bitcoin-$BITCOIN_VERSION-$(uname -m)-linux-gnu.tar.gz" && \
    wget https://bitcoin.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc && \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 && \
    gpg --batch --verify SHA256SUMS.asc && \
    sha256sum -c SHA256SUMS.asc --ignore-missing --status && \
    tar xf bitcoin-*.tar.gz --strip-components=1

########

FROM ubuntu:latest
COPY --from=prep --chown=root:root /app/bin /usr/local/bin

ARG USER_ID
ARG GROUP_ID

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

RUN groupadd -g ${GROUP_ID} user && \
    useradd -u ${USER_ID} -g user -s /bin/bash -m -d /home/user user

USER user
EXPOSE 8332 8333
WORKDIR /home/user
ENTRYPOINT [ "bitcoind" ]

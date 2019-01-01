FROM debian:stable-slim

ENV HOME /bitcoinsv

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV BSV_VERSION=0.1.0

RUN groupadd -g ${GROUP_ID} bitcoinsv \
  && useradd -u ${USER_ID} -g bitcoinsv -s /bin/bash -m -d /bitcoinsv bitcoinsv \
  && set -x \
  && apt-get update -y \
  && apt-get install -y curl gosu \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://github.com/bitcoin-sv/bitcoin-sv/releases/download/v${BSV_VERSION}/bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz | tar xz --strip=2 -C /usr/local/bin

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/bsv_oneshot

VOLUME ["/bitcoinsv"]

EXPOSE 8432 8433

WORKDIR /bitcoinsv

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bsv_oneshot"]
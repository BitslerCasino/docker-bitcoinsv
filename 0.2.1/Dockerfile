FROM bitsler/wallet-base:latest

ENV HOME /bitcoinsv

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV BSV_VERSION=0.2.1

RUN groupadd -g ${GROUP_ID} bitcoinsv \
  && useradd -u ${USER_ID} -g bitcoinsv -s /bin/bash -m -d /bitcoinsv bitcoinsv \
  && set -x \
  && apt-get update -y \
  && apt-get install -y curl gosu \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://download.bitcoinsv.io/bitcoinsv/${BSV_VERSION}/bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz | tar xz --strip=2 -C /usr/local/bin

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/bsv_oneshot

VOLUME ["/bitcoinsv"]

EXPOSE 8932 8933

WORKDIR /bitcoinsv

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bsv_oneshot"]

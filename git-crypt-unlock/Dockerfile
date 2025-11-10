FROM debian:stable

RUN apt-get update  \
  && apt-get install -y git-crypt \
  && apt-get clean

RUN git config --system --add safe.directory '*'

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]

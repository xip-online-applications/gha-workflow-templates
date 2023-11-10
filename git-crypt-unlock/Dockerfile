FROM debian:latest

RUN apt-get update  \
    && apt-get install -y git-crypt \
    && apt-get clean

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]

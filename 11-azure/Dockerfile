FROM postgres:11-alpine

RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
RUN pip install azure-cli

COPY docker-entrypoint.sh /usr/local/bin/
COPY backup.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["run-cron"]

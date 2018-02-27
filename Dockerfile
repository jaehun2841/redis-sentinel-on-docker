FROM lgatica/redis-sentinel

MAINTAINER Carrey (jaehun.lee@ticketlink.co.kr)

## Copy Redis File
## 복사/추가 하는파일의 Container내 경로는 항상 절대경로로 작성하여야 한다.
RUN rm -rf /usr/local/bin/sentinel-entrypoint.sh
ADD sentinel.conf /usr/local/bin/sentinel.conf
RUN touch /usr/local/bin/sentinel.log
ADD sentinel-entrypoint.sh /usr/local/bin/sentinel-entrypoint.sh

## change access authority
RUN chmod 755 /usr/local/bin/sentinel.conf
RUN chmod 755 /usr/local/bin/sentinel.log
RUN chmod 755 /usr/local/bin/sentinel-entrypoint.sh

RUN chown redis:redis /usr/local/bin/sentinel.conf
RUN chown redis:redis /usr/local/bin/sentinel.log
RUN chown redis:redis /usr/local/bin/sentinel-entrypoint.sh

EXPOSE $CLIENTPORT
ENTRYPOINT ["/usr/local/bin/sentinel-entrypoint.sh"]
CMD [ "redis-server","/usr/local/bin/sentinel.conf", "--sentinel" ]

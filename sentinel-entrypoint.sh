#!/bin/sh
set -e

## from redis-4.0.8
sed -i "s/bind 127.0.0.1/bind $CLIENTHOST/g" /usr/local/bin/sentinel.conf
sed -i "s/port 26379/port $CLIENTPORT/g" /usr/local/bin/sentinel.conf
sed -i "s/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster $MASTERHOST $MASTERPORT $QUORUM/g" /usr/local/bin/sentinel.conf
sed -i "s/sentinel down-after-milliseconds mymaster 30000/sentinel down-after-milliseconds mymaster $DOWN_AFTER_MILLISEC/g" /usr/local/bin/sentinel.conf
sed -i "s/sentinel failover-timeout mymaster 180000/sentinel failover-timeout mymaster $FAILOVER_TIMEOUT/g" /usr/local/bin/sentinel.conf
sed -i "s/# sentinel auth-pass mymaster MySUPER--secret-0123passw0rd/sentinel auth-pass mymaster $REQUIREPASS/g" /usr/local/bin/sentinel.conf
#sed -i "s/# requirepass foobared/requirepass $REQUIREPASS/g" /usr/local/bin/sentinel.conf
#sed -i "s/# masterauth <master-password>/masterauth $REQUIREPASS/g" /usr/local/bin/sentinel.conf

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	chown -R redis .
	exec su-exec redis "$@"
fi

exec "$@"
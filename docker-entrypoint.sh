#!/bin/bash

function exitColumnStore {
  echo 'trapped...'
  /usr/local/mariadb/columnstore/bin/columnstore stop
  exit 0
}

env
rm -f /var/run/syslogd.pid
/usr/local/mariadb/columnstore/bin/columnstore stop && /usr/local/mariadb/columnstore/bin/columnstore start

trap exitColumnStore SIGHUP SIGINT SIGTERM SIGQUIT
exec "$@" &
wait

exit 1
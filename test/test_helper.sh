#!/bin/bash

setup() {
  export OLD_DATA_DIRECTORY="$DATA_DIRECTORY"
  export DATA_DIRECTORY=/tmp/datadir
  mkdir "$DATA_DIRECTORY"

  export WORK_DIR=/tmp/work
}

teardown() {
  stop_pg

  rm -rf "$DATA_DIRECTORY"
  export DATA_DIRECTORY="$OLD_DATA_DIRECTORY"
  unset OLD_DATA_DIRECTORY

  rm -f "${CONF_DIRECTORY}/postgresql.conf"
  rm -rf "${CONF_DIRECTORY}/ssl"

  rm -rf "$WORK_DIR"
  unset WORK_DIR
}

initialize_and_start_pg() {
  PASSPHRASE=foobar /usr/bin/run-database.sh --initialize
  start_pg
}

wait_for_pg() {
  until /etc/init.d/postgresql status; do sleep 0.1; done
}

stop_pg() {
  /etc/init.d/postgresql stop || true
  while /etc/init.d/postgresql status; do sleep 0.1; done
}

start_pg() {
  /usr/bin/run-database.sh > /tmp/postgres.log 2>&1 &
  wait_for_pg
}

restart_pg() {
  stop_pg
  start_pg
}

install-heartbleeder() {
  wget http://gobuild.io/github.com/titanous/heartbleeder/master/linux/amd64
  mv amd64 heartbleeder.zip
  unzip heartbleeder.zip -d heartbleeder/
}

uninstall-heartbleeder() {
  rm -rf heartbleeder.zip heartbleeder
}

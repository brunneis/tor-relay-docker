#!/bin/bash

# Tor relay entrypoint
# Copyright (C) 2017-2018 Rodrigo Martínez <dev@brunneis.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ "$(whoami)" == "root" ]; then
  useradd -s /bin/bash -u $HOST_UID tor 2> /dev/null

  if [ $? -eq 0 ]; then
    echo -e "export NICKNAME='${NICKNAME:-NotProvided}'\n\
export CONTACT_INFO='${CONTACT_INFO:-NotProvided}'\n\
export OR_PORT='${OR_PORT:-9001}'\n\
export DIR_PORT='${DIR_PORT:-9030}'\n\
export CONTROL_PORT='${CONTROL_PORT:-9051}'\n\
export BANDWIDTH_RATE='${BANDWIDTH_RATE:-1 MBits}'\n\
export BANDWIDTH_BURST='${BANDWIDTH_BURST:-2 MBits}'\n\
export MAX_MEM='${MAX_MEM:-512 MB}'\n\
export ACCOUNTING_MAX='${ACCOUNTING_MAX:-0}'\n\
export ACCOUNTING_START='${ACCOUNTING_START:-month 1 00:00}'" > /home/tor/env.sh \
    && chown -R tor:tor /home/tor
  fi

  su -c "/entrypoint.sh $1" - tor
  exit
fi

CONF_FILE=/home/tor/torrc
source ~/env.sh

echo -e "SocksPort 0\n\
DataDirectory /home/tor/data\n\
DisableDebuggerAttachment 0\n\
ORPort $OR_PORT\n\
ControlPort $CONTROL_PORT\n\
Nickname $NICKNAME\n\
ContactInfo $CONTACT_INFO\n\
RelayBandwidthRate $BANDWIDTH_RATE\n\
RelayBandwidthBurst $BANDWIDTH_BURST\n\
MaxMemInQueues $MAX_MEM\n\
AccountingMax $ACCOUNTING_MAX\n\
AccountingStart $ACCOUNTING_START" > $CONF_FILE

if [ "$1" == "middle" ]; then
  echo -e "ExitRelay 0\n\
ExitPolicy reject *:*\n\
DirPort $DIR_PORT" >> $CONF_FILE
fi

if [ "$1" == "bridge" ]; then
  echo -e "ExitRelay 0\n\
ExitPolicy reject *:*\n\
BridgeRelay 1" >> $CONF_FILE
fi

if [ "$1" == "exit" ]; then
  echo -e "DirPort $DIR_PORT\n\
ExitPolicy reject 0.0.0.0/8:*\n\
ExitPolicy reject 10.0.0.0/8:*\n\
ExitPolicy reject 44.128.0.0/16:*\n\
ExitPolicy reject 127.0.0.0/8:*\n\
ExitPolicy reject 192.168.0.0/16:*\n\
ExitPolicy reject 169.254.0.0/15:*\n\
ExitPolicy reject 172.16.0.0/12:*\n\
ExitPolicy reject 62.141.55.117:*\n\
ExitPolicy reject 62.141.54.117:*\n\
ExitPolicy accept *:*" >> $CONF_FILE
fi

exec /usr/local/bin/tor -f ~/torrc

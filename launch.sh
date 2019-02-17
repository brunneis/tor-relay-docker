#!/bin/bash

# Tor relay launcher
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

################################################################################
# Usage example: ./launch.sh brunneis/tor-relay-arm:x86-64 middle
#
# arg1 - Docker image
# arg2 - Tor relay type (bridge, middle or exit)
################################################################################

source ./env.sh
DOCKER_IMAGE=${1:-brunneis/tor-relay-arm:x86-64}
RELAY_TYPE=${2:-bridge}

for PORT in $OR_PORT; do
    OR_PORT_DOCKER=$PORT
    break
done

docker run -id \
-p $OR_PORT_DOCKER:$OR_PORT_DOCKER \
-p $DIR_PORT:$DIR_PORT \
-e "OR_PORT=$OR_PORT" \
-e "DIR_PORT=$DIR_PORT" \
-e "NICKNAME=$NICKNAME" \
-e "CONTACT_INFO=$CONTACT_INFO" \
-e "BANDWIDTH_RATE=$BANDWIDTH_RATE" \
-e "BANDWIDTH_BURST=$BANDWIDTH_BURST" \
-e "MAX_MEM=$MAX_MEM" \
-e "ACCOUNTING_MAX=$ACCOUNTING_MAX" \
-e "ACCOUNTING_START=$ACCOUNTING_START" \
-e "HOST_UID=$UID" \
-v $(pwd)/tor-data:/home/tor/data:Z \
--name tor-$RELAY_TYPE-relay $DOCKER_IMAGE $RELAY_TYPE

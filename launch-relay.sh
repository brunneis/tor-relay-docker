#!/bin/bash

# Tor relay launcher
# Copyright (C) 2017 Rodrigo Martínez <dev@brunneis.com>
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
# Usage example: ./launch-relay.sh brunneis/tor-relay-arm:x86-64 middle
#
# arg1 - Docker image
# arg2 - Tor relay type (bridge, middle or exit)
#
################################################################################

OR_PORT=9001
DIR_PORT=9030
NICKNAME=NotProvided
CONTACT_INFO=not-provided@example.com
BANDWIDTH_RATE="250 KBytes"
BANDWIDTH_BURST="500 KBytes"
MAX_MEM="512 MB"

docker run -d \
-p $OR_PORT:$OR_PORT \
-p $DIR_PORT:$DIR_PORT \
-e "OR_PORT=$OR_PORT" \
-e "DIR_PORT=$DIR_PORT" \
-e "NICKNAME=$NICKNAME" \
-e "CONTACT_INFO=$CONTACT_INFO" \
-e "BANDWIDTH_RATE=$BANDWIDTH_RATE" \
-e "BANDWIDTH_BURST=$BANDWIDTH_BURST" \
-e "MAX_MEM=$MAX_MEM" \
-e "HOST_UID=$UID" \
-v $(pwd)/tor-data:/home/tor/data:Z \
--name tor-$2-relay $1 $2

#!/bin/bash

# Tor relay updater
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
# Usage example: ./update-relay.sh brunneis/tor-relay-arm:x86-64 middle
#
# arg1 - Docker image
# arg2 - Tor relay type (bridge, middle or exit)
################################################################################

# Kill the running container
docker rm -f tor-$2-relay

# Look for image updates
docker pull $1

# Relaunch the container
./launch-relay.sh $1 $2

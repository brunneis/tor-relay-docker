#!/bin/bash

# Tor relay Dockerfile generator
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

ARCHS=(x86-64
       armhf
       arm64)

SOURCE_IMAGES=(ubuntu:16.04
               brunneis/ubuntu-armhf:xenial
               brunneis/ubuntu-arm64:xenial)

VARIANTS=(tor-relay tor-relay-arm)

for i in $(seq 0 $((${#ARCHS[@]} - 1)))
  do
    for variant in ${VARIANTS[@]}
      do
        current_dir=$variant/${ARCHS[$i]}
        mkdir -p $current_dir
        if [ "$variant" == "tor-relay-arm" ]; then
          ./dockerfile.sh brunneis/tor-relay:${ARCHS[$i]} $variant \
            > $current_dir/Dockerfile
        else
          ./dockerfile.sh ${SOURCE_IMAGES[$i]} $variant \
            > $current_dir/Dockerfile
          cp entrypoint.sh $current_dir/entrypoint.sh
        fi
      done
  done

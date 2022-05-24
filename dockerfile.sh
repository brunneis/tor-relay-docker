#!/bin/bash

# Dockerfile generator for a Tor relay image
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
# Usage example: ./dockerfile.sh ubuntu:xenial tor-relay > Dockerfile
#
# arg1 - Docker image
# arg2 - Image variant (tor-relay or tor-relay-arm)
################################################################################

source env.sh

if [ "$2" == "tor-relay" ]; then
  cat <<EOF
# Tor relay from source
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

FROM $1
MAINTAINER "Rodrigo Martínez" <dev@brunneis.com>

################################################
# TOR RELAY
################################################

ENV TOR_VERSION $TOR_VERSION
ENV TOR_TARBALL_NAME tor-\$TOR_VERSION.tar.gz
ENV TOR_TARBALL_LINK https://dist.torproject.org/\$TOR_TARBALL_NAME
ENV TOR_TARBALL_ASC \$TOR_TARBALL_NAME.asc

RUN \\
  apt-get update \\
  && apt-get -y upgrade \\
  && apt-get -y install \\
    wget \\
    make \\
    gcc \\
    libevent-dev \\
    libssl-dev \\
    gnupg \\
    zlib1g-dev \\
  && apt-get clean

RUN \\
  wget \$TOR_TARBALL_LINK \\
  && wget \$TOR_TARBALL_LINK.sha256sum \\
  && sha256sum -c \$TOR_TARBALL_NAME.sha256sum \\
  && wget \$TOR_TARBALL_LINK.sha256sum.asc \\
  && gpg --keyserver keys.openpgp.org --recv-keys 514102454D0A87DB0767A1EBBE6A0531C18A9179 \\
  && gpg --keyserver keys.openpgp.org --recv-keys B74417EDDF22AC9F9E90F49142E86A2A11F48D36 \\
  && gpg --verify \$TOR_TARBALL_NAME.sha256sum.asc \\
  && tar xvf \$TOR_TARBALL_NAME \\
  && cd tor-\$TOR_VERSION \\
  && ./configure \\
  && make \\
  && make install \\
  && cd .. \\
  && rm -r tor-\$TOR_VERSION \\
  && rm \$TOR_TARBALL_NAME \\
  && rm \$TOR_TARBALL_NAME.sha256sum \\
  && rm \$TOR_TARBALL_NAME.sha256sum.asc


RUN \\
  apt-get -y remove \\
    wget \\
    make \\
    gcc \\
    libevent-dev \\
    libssl-dev \\
    zlib1g-dev \\
  && apt-get clean

COPY entrypoint.sh /
RUN chmod +rx entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EOF
fi

if [ "$2" == "tor-relay-arm" ]; then
  cat <<EOF
# Tor relay from source with ARM (Anonymizing Relay Monitor)
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

FROM $1
MAINTAINER "Rodrigo Martínez" <dev@brunneis.com>

################################################
# TOR RELAY WITH ARM
################################################

ENV TERM=xterm
RUN \\
  apt-get update \\
  && apt-get -y upgrade \\
  && apt-get -y install \\
     tor-arm \\
  && apt-get clean
EOF
fi

# Tor relay from source
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

FROM brunneis/ubuntu-armhf:xenial
MAINTAINER "Rodrigo Martínez" <dev@brunneis.com>

################################################
# TOR RELAY
################################################

ENV TOR_VERSION 0.3.2.10
ENV TOR_TARBALL_NAME tor-$TOR_VERSION.tar.gz
ENV TOR_TARBALL_LINK https://dist.torproject.org/$TOR_TARBALL_NAME
ENV TOR_TARBALL_ASC $TOR_TARBALL_NAME.asc
ENV TOR_GPG_KEY 0x6AFEE6D49E92B601

RUN \
  apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
    wget \
    make \
    gcc \
    libevent-dev \
    libssl-dev \
  && apt-get clean

RUN \
  wget $TOR_TARBALL_LINK \
  && wget $TOR_TARBALL_LINK.asc \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys $TOR_GPG_KEY \
  && gpg --verify $TOR_TARBALL_NAME.asc \
  && tar xvf $TOR_TARBALL_NAME \
  && cd tor-$TOR_VERSION \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -r tor-$TOR_VERSION \
  && rm $TOR_TARBALL_NAME \
  && rm $TOR_TARBALL_NAME.asc

RUN \
  apt-get -y remove \
    wget \
    make \
    gcc \
    libevent-dev \
    libssl-dev \
  && apt-get clean

COPY entrypoint.sh /
RUN chmod +rx entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

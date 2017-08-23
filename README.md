# tor-relay-docker
Tor relay Docker images for x86-64, armhf &amp; arm64 (from source).

There are pre-built ubuntu-based images hosted in [hub.docker.com](https://hub.docker.com/r/brunneis) (Ubuntu 16.04 LTS) that can be easily executed with `launch-relay.sh`.

__Tor__
- [brunneis/tor-relay:x86-64](https://hub.docker.com/r/brunneis/tor-relay/tags/)
- [brunneis/tor-relay:armhf](https://hub.docker.com/r/brunneis/tor-relay/tags/)
- [brunneis/tor-relay:arm64](https://hub.docker.com/r/brunneis/tor-relay/tags/)

__Tor with ARM (Anonymizing Relay Monitor)__
- [brunneis/tor-relay-arm:x86-64](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/)
- [brunneis/tor-relay-arm:armhf](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/)
- [brunneis/tor-relay-arm:arm64](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/)

## How to launch a Tor relay (launch-relay.sh)
Usage example: `./launch-relay.sh brunneis/tor-relay:x86-64 middle`
- arg1 - Docker image
- arg2 - Tor relay type (bridge, middle or exit)

Within the script several environment variables can be modified:
- OR_PORT
- DIR_PORT 
- NICKNAME
- CONTACT_INFO
- BANDWIDTH_RATE
- BANDWIDTH_BURST
- MAX_MEM

The data directory of Tor (contains the fingerprints and keys among other files) will be mounted in the folder `tor-data` within the directory from which the script is executed. The docker image will run with the user `tor` with the same `UID` as the user who launches the script.

## dockerfile.sh
This bash script generates a Dockerfile. It should work with modern Ubuntu base images of any architecture.
Two kinds of dockerfiles can be generated:
- __tor-relay__: with Tor built from source
- __tor-rela-arm__: based on an already tor-relay image plus ARM.

Usage example: `./dockerfile.sh ubuntu:xenial tor-relay > Dockerfile`
- arg1 - Docker image
- arg2 - image variant (tor-relay or tor-relay-arm)

## entrypoint.sh
The entrypoint for all the tor-relay images. It will create the user `tor` and configure the `torrc` file depending on the relay type. Finally it will `exec` Tor.

## How to build the images (build-images.sh)
This bash script contains three arrays: `ARCHS`, `SOURCE_IMAGES` and `VARIANTS`. It will create the directories for both kind of images (tor-relay and tor-relay-arm) and for the specified architectures in `ARCHS`. The arrays `ARCHS` and `SOURCE_IMAGES` act as an ordered dictionary so they should be written coherently. The provided images in `SOURCE_IMAGES` must be compatible with the host architecture.

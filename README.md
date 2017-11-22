# tor-relay-docker (0.3.1.8)
Tor relay Docker images for x86-64, armhf &amp; arm64 (from source).

There are pre-built ubuntu-based images hosted in
[hub.docker.com](https://hub.docker.com/r/brunneis)
(Ubuntu 16.04 LTS) that can be easily executed with the `launch-relay.sh` script.

__Tor__ (Tor built from source)
- [brunneis/tor-relay:x86-64](https://hub.docker.com/r/brunneis/tor-relay/tags/) (latest stable)
- [brunneis/tor-relay:armhf](https://hub.docker.com/r/brunneis/tor-relay/tags/) (latest stable)
- [brunneis/tor-relay:arm64](https://hub.docker.com/r/brunneis/tor-relay/tags/) (latest stable)
- [brunneis/tor-relay:0.3.1.8_x86-64](https://hub.docker.com/r/brunneis/tor-relay/tags/)
- [brunneis/tor-relay:0.3.1.8_armhf](https://hub.docker.com/r/brunneis/tor-relay/tags/)
- [brunneis/tor-relay:0.3.1.8_arm64](https://hub.docker.com/r/brunneis/tor-relay/tags/)

__Tor with ARM (Anonymizing Relay Monitor)__ (based on tor-relay images)
- [brunneis/tor-relay-arm:x86-64](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/) (latest stable)
- [brunneis/tor-relay-arm:armhf](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/) (latest stable)
- [brunneis/tor-relay-arm:arm64](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/) (latest stable)
- [brunneis/tor-relay-arm:0.3.1.8_x86-64](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/)
- [brunneis/tor-relay-arm:0.3.1.8_armhf](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/)
- [brunneis/tor-relay-arm:0.3.1.8_arm64](https://hub.docker.com/r/brunneis/tor-relay-arm/tags/)


## How it works
The common entrypoint for all the tor-relay images is the `entrypoint.sh` script. Before launching Tor, it will create the user `tor` and configure the `torrc` file depending on the relay type and the configured environment variables. The Tor data directory will be mounted in the folder `tor-data` within the directory from which the script is executed. The docker image will run with the user `tor` with the same `UID` as the user who runs the container. The identity of the executed relay is kept under the `tor-data` folder, so the container can be destroyed and relaunched while the relay identity is preserved.

## How to launch a Tor relay
You can modify the basic environment variables of the `launch-relay.sh` script
(NICKNAME and CONTACT_INFO) and just launch it as follows, where the first argument
is the tor-relay image and the second one, the relay type:

- __Bridge relay__: `./launch-relay.sh brunneis/tor-relay:x86-64 bridge`
- __Middle relay__: `./launch-relay.sh brunneis/tor-relay:x86-64 middle`
- __Exit relay__: `./launch-relay.sh brunneis/tor-relay:x86-64 exit`

Currently, it is possible to configure also the following variables when
launching a dockerized relay and all of them come with default values:
- OR_PORT
- DIR_PORT
- BANDWIDTH_RATE
- BANDWIDTH_BURST
- MAX_MEM

If you want to run a Docker image directly just set the previous environment
variables and bind a volume for the Tor data as shown bellow:

- __Bridge relay__:
`docker run -d -p 9001:9001 -e "OR_PORT=9001" -e "NICKNAME=YourRelayNickname" -e "CONTACT_INFO=contact@example.com" -e "BANDWIDTH_RATE=250 KBytes" -e "BANDWIDTH_BURST=500 KBytes" -e "MAX_MEM=512 MB" -e "HOST_UID=$UID" -v $(pwd)/tor-data:/home/tor/data:Z --name tor-bridge-relay brunneis/tor-relay:x86-64 bridge`

- __Middle relay__:
`docker run -d -p 9001:9001 -p 9030:9030 -e "OR_PORT=9001" -e "DIR_PORT=9030" -e "NICKNAME=YourRelayNickname" -e "CONTACT_INFO=contact@example.com" -e "BANDWIDTH_RATE=250 KBytes" -e "BANDWIDTH_BURST=500 KBytes" -e "MAX_MEM=512 MB" -e "HOST_UID=$UID" -v $(pwd)/tor-data:/home/tor/data:Z --name tor-middle-relay brunneis/tor-relay:x86-64 middle`

- __Exit relay__:
`docker run -d -p 9001:9001 -p 9030:9030 -e "OR_PORT=9001" -e "DIR_PORT=9030" -e "NICKNAME=YourRelayNickname" -e "CONTACT_INFO=contact@example.com" -e "BANDWIDTH_RATE=250 KBytes" -e "BANDWIDTH_BURST=500 KBytes" -e "MAX_MEM=512 MB" -e "HOST_UID=$UID" -v $(pwd)/tor-data:/home/tor/data:Z --name tor-exit-relay brunneis/tor-relay:x86-64 exit`

## How to update a running Tor relay to the latest stable version
When launching a Tor relay with the `launch-relay.sh` script, you can update the Tor software with the last stable version directly running the `update-relay.sh` script. For manual updates, you can just kill the running container, pull or build the new Docker image and rerun the container binding the same data directory.

## Generate dockerfiles
The script `gen-dockerfiles.sh` is intended to generate the build contexts for all the supported
architectures (x86-64, armhf & arm64) and variants (tor-relay & tor-relay-arm). It has no arguments and makes use of the `dockerfile.sh` script, which generates a Dockefile given a base image and a variant.
The generated dockerfiles were designed to work with modern Ubuntu images and should work with other architectures which Ubuntu support. Note that the `tor-relay-arm` generated images need to use a `tor-relay` base image to work.

Usage example: `./dockerfile.sh ubuntu:xenial tor-relay > Dockerfile`
- arg1 - Docker image
- arg2 - image variant (tor-relay or tor-relay-arm)

## How to build the images
The `build-arch-images.sh` script will build all the Docker images for the given architectures as parameters. The images can be manually built with the `docker build` command within every generated Docker context.

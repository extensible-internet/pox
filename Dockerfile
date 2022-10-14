# NB: enable ipv6 in Docker daemon, or tests will fail
#     https://docs.docker.com/config/daemon/ipv6
#
# /etc/docker/daemon.json:
# {
#   "ipv6": true,
#   "fixed-cidr-v6": "fd00::/80"
# }
FROM ubuntu:22.04

ARG USER=groove

RUN apt-get update && \
      TZ=Etc/UTC DEBIAN_FRONTEND=noninteractive apt-get install -y \
          git \
          cmake \
          clang-12 \
          libclang-12-dev \
          libstdc++-10-dev \
          libpthread-stubs0-dev \
          libcap-ng-dev \
          doctest-dev \
          python3-pip \
          python3-fasteners \
          cppcheck \
          sudo \
# tests
          libcap2-bin \
          netcat-openbsd \
          wget \
          gawk \
# extra
          tmux \
          cmake-curses-gui \
          python3-tblib \
          linux-tools-generic \
          linux-headers-$(uname -r) \
          tcpdump \
          atop \
          python3-kazoo \
          zookeeper

# EI scripts rely on sudo; make user w/ passwordless sudo
RUN useradd -ms /bin/bash $USER && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && usermod -aG sudo $USER
USER $USER

ENV PATH="/home/$USER/.local/bin:$PATH"

WORKDIR /home/$USER
COPY --chown=$USER:$USER . pox
WORKDIR pox/ext/ei
RUN scripts/build_all.sh --install --with-tests --clean --parallel

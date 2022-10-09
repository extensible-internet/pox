FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

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
          tcpdump \
          atop \
          python3-kazoo \
          zookeeper

# don't have credentials to clone EI in this stage
# see postCreateCommand.sh

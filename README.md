# Dsig artifacts
## Prerequisites
To install the prerequisites on Ubuntu 20.04:
```sh
# Install basic dependencies
apt-get update && apt-get -y install \
                                 sudo file unzip zip xz-utils zstd vim nano git \
                                 tree python3 python3-pip tmux bash-completion

pip3 install pipenv

## Enable SSH
rm -f /etc/service/sshd/down

mkdir ~/.ssh/
cp config/id_ed25519 ~/.ssh/id_ed25519
chmod 400 ~/.ssh/id_ed25519
cp config/config ~/.ssh/config
cp config/id_ed25519.pub ~/.ssh/authorized_keys
touch ~/.hushlogin

# Install OFED drivers which include libibverbs-dev among other things (e.g., ib_write_bw which otherwise is part of perftest) 
cd /opt && curl -OL http://www.mellanox.com/downloads/ofed/MLNX_OFED-5.3-1.0.0.1/MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu20.04-x86_64.tgz && tar xf MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu20.04-x86_64.tgz
cd /opt/MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu20.04-x86_64 && ./mlnxofedinstall --force --without-fw-update --user-space-only --vma

# Install CMake
echo 'deb [trusted=yes] https://apt.kitware.com/ubuntu/ focal main' > /etc/apt/sources.list.d/kitware.list
apt-get update && apt-get -y install cmake

# Install basic dory dependencies and tools
apt-get update && apt-get -y install \
                                 sudo coreutils util-linux gawk \
                                 python3 python3-pip zip tmux \
                                 gcc g++ ninja-build \
                                 numactl libmemcached-dev libnuma-dev
# Install extra dependencies
apt-get -y install libssl-dev
```

To compile, also install:
```sh
apt-get update && apt-get -y install clang-10 lld-10 clang-format-10 clang-tidy-10 clang-tools-10

# Fix the LLD path
# (If we install `lld` instead of `lld-10`, the following command is not needed)
update-alternatives --install "/usr/bin/ld.lld" "ld.lld" "/usr/bin/ld.lld-10" 20

# Install extra dependencies
apt-get -y install clang-format-10 clang-tidy-10 clang-tools-10 git

# Install essential python packages
pip3 install --upgrade "conan>=1.63.0,<2.0.0"

# Install extra python packages
#RUN pip3 install --upgrade cmake-format black halo pyyaml"<6.0,>=3.11"
pip3 install --upgrade cmake-format black halo

# RUN conan profile new default --detect
# RUN conan profile update settings.compiler.libcxx=libstdc++11 default
```

To run, also install:
```sh
apt-get update && apt-get -y install memcached redis
```

## Clone
Clone this repository, including the dsig submodule:
```sh
git clone https://github.com/LPD-EPFL/dsig-artifacts.git --recurse-submodules
cd dsig-artifacts
```

Or alternatively:
```sh
git clone https://github.com/LPD-EPFL/dsig-artifacts.git
cd dsig-artifacts
git clone https://github.com/LPD-EPFL/dsig.git bin/dsig
```

## Build dsig and prepare deployment
To build dsig, simply run:
```sh
./bin/dsig/build.sh distclean buildclean clean
./bin/dsig/build.sh dsig dsig-apps
```

Note: building dsig can take a while (10~20min on our setup), as many configurations are compiled in separate binaries.

Binaries for dsig and dsig's applications will appear in `bin/dsig/dsig/build/bin` and `bin/dsig/dsig-apps/build/bin` respectively.

Then, zip binaries for later deployment:
```sh
./bin/zip-binaries.sh
```

Finally, prepare the `deployment.zip` file using:
```sh
./prepare-deployment.sh
```

## Deploy

To deploy, you will need to:
- send this zip files to all the servers
- unzip the files in the `~/dsig-artifacts` directory
- also unzip `~/dsig-artifacts/bin/bin.zip` in the ``~/dsig-artifacts/bin` directory.

On our setup, this can be done using:
```sh
./send-deployment.sh
```

The `~/dsig-artifacts` should contain the `bin`, `experiments`, `scripts` and `toml` subfolders.

## Run experiments

TODO
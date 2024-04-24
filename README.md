# Overview
DSig is a microsecond-scale signature system for the datacenter.

This repository contains the artifacts and the instructions needed to reproduce the experiments in our OSDI paper.
More precisely, it contains:
* Instructions on how to configure a cluster to deploy and run the experiments.
* Instructions on how to build and deploy the payloads of the experiments.
* Instructions on how to launch the experiments and obtain the results.

## Claims

By running the experiments, you should be able to reproduce the numbers shown in:
* **Figure 6**: Latency to sign, transmit and verify using different configurations of DSig.
* **Figure 7**: End-to-end latency of different applications when using either Sodium, Dalek or DSig.
* **Figure 8**: Latency CDFs of the different schemes, and their latency to sign, transmit and verify.
* **Figure 9**: Latency of the different schemes with message sizes from 8 B to 8 KiB.
* **Figure 10**: Latency-throughput graphs of the different schemes.
* **Figure 11**: Throughput with different numbers of verifiers and signers for Dalek and DSig.
* **Figure 12**: Throughput of a synthetic application when using no crypto, Dalek or DSig.
* **Figure 13**: Latency and throughput for different DSig batch sizes.
* **Table 1**: Latency to sign, transmit and verify for Dalek and DSig. Signature generation and verification throughputs for Dalek and DSig.

## Getting Started Instructions

Assuming you have access to a pre-configured cluster, you will be able to run a first experiment
that measures the end-to-end latency of different apps for various signature schemes (figure 7) in less than 30 minutes by:
1. Connecting to the pre-configured cluster's gateway,
2. [Building and deploying the evaluation binaries](##Building-and-Deploying-the-Binaries),
3. [Running the script for figure 7](##Running-Experiments).

# Detailed instructions

This section will guide you on how to configure, build, and run all the experiments **from scratch**.
If you have access to a pre-configured cluster, skip to [building and deploying the binaries](##Building-and-Deploying-the-Binaries).

## Cluster Configuration

### Cluster Prerequisites

Running all experiments requires:
* a cluster of 4 machines connected via an InfiniBand fabric,
* Ubuntu 20.04 (different systems may work, but they have not been tested),
* all machines having the following ports open: 7000-7100, 11211, 18515, 9998.

### Deployment Dependencies

#### Gateway Dependencies

The artifacts are built and packaged into binaries. Subsequently, these binaries are deployed from a *gateway* machine (e.g., your laptop).
The gateway machine requires the following depencencies installed to be able to execute the deployment (and evaluation) scripts:
```sh
sudo apt install -y coreutils gawk python3 zip tmux
```

#### Cluster Machine Dependencies

The cluster machines, assuming they are already setup for InfiniBand+RDMA, require the following dependencies to be able to execute the binaries:
```sh
sudo apt install -y coreutils gawk python3 zip tmux gcc numactl libmemcached-dev memcached redis
```

The proper version of Mellanox OFED's InfiniBand drivers can be installed on the cluster machines via:
```sh
wget http://www.mellanox.com/downloads/ofed/MLNX_OFED-5.3-1.0.0.1/MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu20.04-x86_64.tgz
tar xf MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu20.04-x86_64.tgz
sudo ./mlnxofedinstall
```

### Build Dependencies

To build the evaluation binaries, you need the dependencies below.
> *Note*: You can build and package the binaries in a cluster machine, the gateway or another machine. It is important, however, that you build the binaries in a machine with the same distro/version as the cluster machines, otherwise the binaries may not work. For example, you can use a docker container to build and package the binaries. Alternatively, you can use one of the machines in the cluster.

Install the required dependencies on a vanilla Ubuntu 20.04 installation via:
```sh
sudo apt-get -y install \
    python3 python3-pip \
    gawk build-essential cmake ninja-build \
    libmemcached-dev \
    libibverbs-dev # only if Mellanox OFED is not installed.

pip3 install --upgrade "conan>=1.63.0,<2.0.0"
```

## Building and Deploying the Binaries

Assuming all the machines in your cluster have the same configuration, you need to:
* build all the necessary binaries, for example in a deployment machine,
* package them and deploy them in all 4 machines.

### Recursively Cloning this Repository

First, clone this repository on the gateway, including the dsig submodule, via:
```sh
git clone https://github.com/LPD-EPFL/dsig-artifacts.git --recurse-submodules
cd dsig-artifacts
```

If you are not using our pre-configured cluster, set the proper FQDN of the cluster's machines in `scripts/config.sh`.

### Building the Binaries

Build the evaluation binaries via:
```sh
./bin/dsig/build.sh distclean buildclean clean
./bin/dsig/build.sh dsig dsig-apps
```

> *Note*: as our evaluation tests many different configurations of DSig, compilation can take a while (10~20min on our setup).

Binaries for DSig and DSig's applications will appear in `bin/dsig/dsig/build/bin` and `bin/dsig/dsig-apps/build/bin`, respectively.

### Deploying the Binaries

Zip the binaries and prepare their deployment via:
```sh
./bin/zip-binaries.sh
./prepare-deployment.sh # generates deployment.zip
```

To deploy, you will need to:
- send `deployment.zip` to all the cluster's servers,
- unzip `deployment.zip` in the `~/dsig-artifacts` directory,
- unzip `~/dsig-artifacts/bin/bin.zip` in the ``~/dsig-artifacts/bin` directory.

On our pre-configured cluster, this can be done via:
```sh
./send-deployment.sh
```

As a sanity check, the `~/dsig-artifacts` directory should contain the `bin`, `experiments`, `scripts` and `toml` subfolders.

## Running Experiments

Once the binaries are deployed, you can reproduce the results presented in our paper from the gateway by running the scripts in `experiments/`.
For instance, to reproduce the results of figure 7, run `experiments/apps.sh`.
The logs of the experiments---which translate to the data points presented in our paper---can be found it the `~/dsig-artifacts/logs/` directory of the machines they executed on.
Gather these logs in the gateway's `logs/` directory via:
```sh
./gather-logs.sh
```

Each figure/table maps to different scripts as follows:
* Figure 6: `experiments/wots.sh` and `experiments/hors.sh`,
* Figure 7: `experiments/apps.sh`,
* Figure 8: `experiments/msg-size.sh` (at 8 bytes) and `experiments/miss.sh`,
* Figure 9: `experiments/msg-size.sh`,
* Figure 10: `experiments/tput-short.sh` (fast, for the critical data points) and `experiments/tput.sh` (very slow, for all data points),
* Figure 11: `experiments/scalability.sh`,
* Figure 12: `experiments/synthetic.sh`,
* Figure 13: `experiments/batch-size.sh`,
* Table 1: `experiments/batch-size.sh` (for a batch size of 128 for throughput) and `experiments/msg-size.sh` (at 8B for latency).
# Overview

DSig is a microsecond-scale signature system for the datacenter.

This repository contains the artifacts and the instructions needed to reproduce the experiments in our OSDI paper.
More precisely, it contains:
* Instructions on how to configure a cluster to deploy and run the experiments.
* Instructions on how to build and deploy the payloads of the experiments.
* Instructions on how to launch the experiments and obtain the results.

## Claims

By running the experiments, you should be able to reproduce the numbers shown in:
* **Figure 1**: Latency of an auditable KVS, BFT broadcast and BFT replication with EdDSA and DSig.
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
2. [Building and deploying the evaluation binaries](#Building-and-Deploying-the-Binaries),
3. [Running the scripts for figure 7](#Running-Experiments).

# Detailed instructions

This section will guide you on how to configure, build, and run all the experiments **from scratch**.
If you have access to a pre-configured cluster, skip to [building and deploying the binaries](#Building-and-Deploying-the-Binaries).

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
    git libssl-dev \
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

> *Note*: as our evaluation tests many different configurations of DSig, compilation can take a while (~5min on our setup).

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
- unzip `~/dsig-artifacts/bin/bin.zip` in the `~/dsig-artifacts/bin` directory.

On our pre-configured cluster, this can be done via:
```sh
./send-deployment.sh
```

As a sanity check, the `~/dsig-artifacts` directory should contain the `bin`, `experiments`, `scripts` and `toml` subfolders.

## Running Experiments

### Resetting Bandwidth Limiters

To ensure, that no bandwidth limiter was left active by a previous user, run the following:
```sh
experiments/reset-rdma-bandwidth.sh
```

> *Note*: Some experiments (fig11, fig12 and fig13) modify the bandwidth temporarily, but they should always return it to normal afterward.
In case one of those experiments crashes or is interupted, make sure to reset the bandwidth before running any other experiment.

### Experiments

Once the binaries are deployed and the full bandwidth is available, you can reproduce the results presented in our paper from the gateway by running the following scripts.
During the kick-the-tires period, we invite you to run the scripts of [figure 7](#figure-7) as a sanity check.

#### Figure 1

```sh
experiments/fig1-intro-latency-of-apps.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig1-intro-latency-of-apps.py # print the data points
```

> *Note*: The results slightly diverge from the accepted paper as the base cost (non-crypto) of BFT replication was underestimated (~23us vs ~46us reported by the script). This means that DSig leads to an even higher reduction of the crypto overhead. We will update the camera ready accordingly.

#### Figure 6

```sh
experiments/fig6-choice-of-hbss.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig6-choice-of-hbss.py # print the data points
```

> *Note*: Due to its extreme sensibility to cache effects, the verification latency of HORS with prefetching (which we do *not* recommend) might underperform the presented results. We will stress this extreme sensibility as another downside in the camera ready.

#### Figure 7

```sh
experiments/fig7-latency-of-apps.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig7-latency-of-apps.py # print the data points
```

> *Note*: Redis base cost (without crypto) seems to have increased by 3us ever since our evaluation.

> *Note*: similarily to [figure 1](#figure-1), the base cost (non-crypto) of uBFT was underestimated (~23us vs ~46us reported by the script). This means that DSig leads to an even higher reduction of the crypto overhead. We will update the camera ready accordingly.

#### Figure 8

```sh
experiments/fig8-latency-cdf.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig8-latency-cdf.py # print the data points
```

> *Note*: Due to the extremely small size of EdDSA signatures, their transmission time is negligible; combined with measurement inaccuracies, this can lead to very small negative latencies being reported.

#### Figure 9

```sh
experiments/fig9-message-size.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig9-message-size.py # print the data points
```

#### Figure 10

```sh
# experiments/fig10-throughput.sh # run the full (slow) experiment
experiments/shorter-fig10-throughput.sh # run a shorter experiment that focuses on the key points
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig10-throughput.py # print the data points
```

#### Figure 11

```sh
experiments/fig11-scalability.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig11-scalability.py # print the data points
```

#### Figure 12

```sh
experiments/fig12-synthetic-app.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig12-synthetic-app.py # print the data points
```

#### Figure 13

```sh
experiments/fig13-batch-size.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/fig13-batch-size.py # print the data points
```

> *Note*: There are 2 typos in the accepted paper: the "2 Ki" ticks should show "4 Ki" and the "65 Ki" ticks should show "64 Ki".

#### Table 1

```sh
experiments/table1-eddsa-vs-dsig.sh # run the experiment
./gather-logs.sh # retrieve the logs from the workers to the gateway
print-datapoints/table1-eddsa-vs-dsig.py # print the data points
```

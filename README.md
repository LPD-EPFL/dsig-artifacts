# Dsig artifacts
## 

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
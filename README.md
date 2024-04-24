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
cd dsig-artifacts/bin
git clone https://github.com/LPD-EPFL/dsig.git
cd ..
```

## Build dsig
To build dsig, simply run:
```sh
cd bin/dsig
./build.py distclean buildclean clean
./build.py dsig dsig-apps
cd ../..
```

Note: building dsig can take a while (10~20min on our setup), as many configurations are compiled in separate binaries.

Binaries for dsig and dsig's applications will appear in `bin/dsig/dsig/build/bin` and `bin/dsig/dsig-apps/build/bin` respectively.

## Deploy
To deploy dsig experiments, first run:
```sh
./prepare-deployment.sh
```
This will produce a `deployment.zip` file.
Then, send this zip files to all the servers, and unzip the files in the home directory.
On our setup, this can be done using:
```sh
./send-deployment.sh
```

The `~/dsig-artifacts` should contain the `bin`, `experiments`, `scripts` and `toml` subfolders.

## Run experiments
TODO
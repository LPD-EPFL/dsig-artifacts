# Use the absolute path
ROOT_DIR='~'
SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

MACHINE_COUNT=4
TMUX_SESSION=dsig

# Set ssh names of the machines
machine1=w1
machine2=w2
machine3=w3
machine4=w4

# Set fqdn names of the machines (use `hostname -f`)
machine1hostname=dsig-$machine1
machine2hostname=dsig-$machine2
machine3hostname=dsig-$machine3
machine4hostname=dsig-$machine4


# Memcached does not run with root access
#DSIG_HAVE_SUDO_ACCESS=false
#DSIG_SUDO_ASKS_PASS=false
#DSIG_SUDO_PASS="MyPass"

machine2ssh () {
    local m=$1
    echo "${!m}"
}

machine2hostname () {
    local m=$1
    local m_hn=${m}hostname
    echo "${!m_hn}"
}

export DSIG_DEPLOYMENT="~/dsig-artifacts"
export TOML_DIR="$DSIG_DEPLOYMENT/toml/"
export DORY_REGISTRY_IP=$(machine2hostname machine1)
export DSIG_CONFIG="$TOML_DIR/dsig.toml"
export DORY_LIB_REPARENT_PATH="$DSIG_DEPLOYMENT/scripts/libreparent.so"
export DSIG_CORES="bg=10"

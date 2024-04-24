# Use the absolute path
ROOT_DIR='~'
SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"

MACHINE_COUNT=4
TMUX_SESSION=ponyng

# Set ssh names of the machines
machine1=dcldelta1
machine2=dcldelta2
machine3=dcldelta3
machine4=dcldelta4

# Set fqdn names of the machines (use `hostname -f`)
machine1hostname=$machine1.epfl.ch
machine2hostname=$machine2.epfl.ch
machine3hostname=$machine3.epfl.ch
machine4hostname=$machine4.epfl.ch


# Memcached does not run with root access
#PONY_HAVE_SUDO_ACCESS=false
#PONY_SUDO_ASKS_PASS=false
#PONY_SUDO_PASS="MyPass"

machine2ssh () {
    local m=$1
    echo "${!m}"
}

machine2hostname () {
    local m=$1
    local m_hn=${m}hostname
    echo "${!m_hn}"
}

export TOML_DIR="$( realpath -sm  $SCRIPT_DIR/../toml/ )"
export DORY_REGISTRY_IP=$(machine2hostname machine1)
export PONY_CONFIG="$TOML_DIR/pony.toml"
export DORY_LIB_REPARENT_PATH="$SCRIPT_DIR/libreparent.so"
export PONY_CORES="bg=10"

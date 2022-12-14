#!/bin/bash
cd /home/
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Update Rust Server
/home/steam/steamcmd/steamcmd.sh +force_install_dir /home/container +login anonymous +app_update 258550 validate +quit

# Replace Startup Variables
echo ":/home/container$ $@"

# OxideMod has been replaced with uMod
if [ -f OXIDE_FLAG ] || [ "${OXIDE}" = 1 ] || [ "${UMOD}" = 1 ]; then
    echo "Updating uMod..."
    curl -sSL "https://github.com/OxideMod/Oxide.Rust/releases/latest/download/Oxide.Rust-linux.zip" > umod.zip
    unzip -o -q umod.zip
    rm umod.zip
    echo "Done updating uMod!"
fi

# Fix for Rust not starting
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

# Run the Server
node /wrapper.js "$@"
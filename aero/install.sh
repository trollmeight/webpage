#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run with root privileges."
   exit 1
fi

curl -o /usr/local/bin/$USER/aero.sh http://trollmeight.me/aero/aero.sh

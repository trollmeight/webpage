#!/bin/bash

rm -rf /usr/local/bin/$USER/aero.sh
rm -rf /usr/local/bin/$USER/aero_external/update.sh
curl -o /usr/local/bin/$USER/aero.sh http://trollmeight.me/aero/aero.sh
mkdir /usr/local/bin/$USER/aero_external
curl -o /usr/local/bin/$USER/aero_external/update.sh http://trollmeight.me/aero/aero_external/update.sh

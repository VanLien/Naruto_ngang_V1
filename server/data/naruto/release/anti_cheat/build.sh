#!/bin/bash
#
rm agent
cd agentproj
make clean
make
cp ./agent ../


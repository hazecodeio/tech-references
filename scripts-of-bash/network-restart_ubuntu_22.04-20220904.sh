#!/bin/bash

sudo bash -c '
echo "Restarting Network in 20 Sec";
ip link set wlp34s0 down;
sleep 20;
ip link set wlp34s0 up
echo "Running SpeedTest in 10 Sec";
sleep 10;
speedtest;
'
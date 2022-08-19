#!/bin/bash

sudo bash -c '
echo "Restarting Network in 20 Sec";
systemctl stop network-manager.service;
sleep 20;
systemctl start network-manager.service;
echo "Running SpeedTest in 10 Sec";
sleep 10;
speedtest;
'
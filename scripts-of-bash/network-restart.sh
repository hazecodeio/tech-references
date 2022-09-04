#!/bin/bash

sudo bash -c '
sudo nmcli networking off;
sudo nmcli  networking on;
echo "Speedtesing after 10 secs...";
sleep 10;
speedtest;
'

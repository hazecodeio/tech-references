#!/bin/bash

bash -c '
nmcli networking off;
nmcli  networking on;
echo "Speedtesing after 10 secs...";
sleep 10;
speedtest;
'

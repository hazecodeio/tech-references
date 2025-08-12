#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {

  local CWD="$(echo $(realpath ${0}) | xargs dirname)"
  source "${CWD}"/_env-loader.sh

  sudo ip netns add "${NS01}"
  sudo ip link add "${vIF01}" link "${IF}" type ipvlan mode l2
  sudo ip link set dev "${vIF01}" up
  sudo ip link set "${vIF01}" netns "${NS01}"

  sudo ip netns add "${NS02}"
  sudo ip link add "${vIF02}" link "${IF}" type ipvlan mode l2
  sudo ip link set dev "${vIF02}" up
  sudo ip link set "${vIF02}" netns "${NS02}"



  sudo ip netns exec "${NS01}" ip link set lo up
  sudo ip netns exec "${NS01}" ip link set "${vIF01}" up

  sudo ip netns exec "${NS02}" ip link set lo up
  sudo ip netns exec "${NS02}" ip link set "${vIF02}" up



  sudo ip netns exec "${NS01}" ip addr add "${IP_HOST}" dev "${vIF01}"
  sudo ip netns exec "${NS01}" ip route add default via "${IP_GW}" dev "${vIF01}"

  sudo ip netns exec "${NS02}" ip addr add "${IP_HOST}" dev "${vIF02}"
  sudo ip netns exec "${NS02}" ip route add default via "${IP_GW}" dev "${vIF02}"


  sudo nmcli connection reload


  #iptable Rules

  sudo iptables -v -t nat -A POSTROUTING -s "${IP_MASK}" -o "${IF}" -j MASQUERADE
  sudo iptables -v -I FORWARD -i "${LINK}" -o "${IF}" -j ACCEPT
  sudo iptables -v -I FORWARD -o "${LINK}" -i "${IF}" -j ACCEPT




  sudo sysctl -q net.ipv4.ip_forward=1


  #sudo -E ip netns exec "${NS}" sudo -E -u haze bash

}

funinit


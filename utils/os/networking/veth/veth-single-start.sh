#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {

  local CWD="$(echo $(realpath ${0}) | xargs dirname)"
  source "${CWD}"/_env-loader.sh

  sudo ip netns add "${NS}"
  sudo ip netns exec "${NS}" ip addr add 127.0.0.1/8 dev lo
  sudo ip netns exec "${NS}" ip link set lo up

  sudo ip link add "${VETH_L}" type veth peer name "${VETH_R}"
  sudo ip link set "${VETH_L}" up
  sudo ip link set "${VETH_R}" netns "${NS}" up
  sudo ip addr add "${IP_NS}" dev "${VETH_L}"
  sudo ip netns exec "${NS}" ip addr add "${IP_HOST}" dev "${VETH_R}"
  sudo ip netns exec "${NS}" ip route add default via "${IP_GW}" dev "${VETH_R}"
  sudo nmcli connection reload


  #iptable Rules

  sudo iptables -t nat -A POSTROUTING -s "${IP_MASK}" -o "${IF}" -j MASQUERADE
  sudo iptables -I FORWARD -i "${VETH_L}" -o "${IF}" -j ACCEPT
  sudo iptables -I FORWARD -o "${VETH_L}" -i "${IF}" -j ACCEPT
  sudo sysctl -q net.ipv4.ip_forward=1


  #DNS
  #vopono_core::network::dns_config > Setting namespace "${NS}" DNS server to 8.8.8.8

  #Exec
  #sudo -E ip netns exec "${NS}" sudo -E -u "${USER}" bash

}

funinit
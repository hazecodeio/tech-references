#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funcinit() {

  local CWD="$(echo $(realpath ${0}) | xargs dirname)"
  source "${CWD}"/_env-loader.sh


  IF=tun0

  vIF01=ipvlan01
  vIF02=ipvlan02

  NS01=ipvlan_ns01
  NS02=ipvlan_ns02


  IP_SUBNET_MASKED=10.200.1.0/24
  IP_NS_MASKED=10.200.1.1/24
  IP_HOST_MASKED=10.200.1.10/24
  IP_GW=10.200.1.1
  DNS=1.1.1.1


  sudo ip netns add "${NS01}"
  sudo ip link add "${vIF01}" link "${IF}" type ipvlan mode l2
  sudo ip link set dev "${vIF01}" up
  sudo ip link set "${vIF01}" netns "${NS01}"


  sudo ip netns exec "${NS01}" ip link set lo up
  sudo ip netns exec "${NS01}" ip link set "${vIF01}" up



  #iptable Rules



#sudo ip route add default via "${IP_NS_MASKED}" dev "${vIF01}"

#  sudo ip address add "${IP_HOST_MASKED}" dev "${vIF01}"
  sudo ip -d netns exec "${NS01}" ip address add "${IP_HOST_MASKED}" dev "${vIF01}"
  sudo ip -d netns exec "${NS01}" ip route add default via "${IP_GW}" dev "${vIF01}"

#  ip netns exec vopono01 ip route add 10.200.2.1 via 10.200.1.1 dev vopono01_s
#  ip netns exec vopono01 ip route add 10.200.2.10 via 10.200.1.1 dev vopono01_s

  sudo iptables -v -t nat -A POSTROUTING -s "${IP_SUBNET_MASKED}" -o "${IF}" -j MASQUERADE
  sudo iptables -v -I FORWARD -i "${vIF01}" -o "${IF}" -j ACCEPT
  sudo iptables -v -I FORWARD -o "${vIF01}" -i "${IF}" -j ACCEPT

  sudo sysctl -q net.ipv4.ip_forward=1


#  DNS

  sudo ip netns exec "${NS01}" iptables -I OUTPUT 1 -d 1.1.1.1 -j ACCEPT
  sudo ip netns exec "${NS01}" iptables -A OUTPUT -p udp -d 1.1.1.1 --dport 53 -j ACCEPT
  sudo ip netns exec "${NS01}" iptables -A OUTPUT -p tcp -d 1.1.1.1 --dport 53 -j ACCEPT

  sudo nmcli connection reload


  #sudo -E ip netns exec "${NS}" sudo -E -u haze bash

}

funcinit


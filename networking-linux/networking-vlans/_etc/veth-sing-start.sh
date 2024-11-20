

export NS=v_ns
export LINK=v_lnk
export VETH=v_eth
export IF=proton0

export IP_MASK=10.200.1.0/24
export IP_NS=10.200.1.1/24
export IP_HOST=10.200.1.2/24
export IP_GW=10.200.1.1

sudo ip netns add $NS
sudo ip netns exec $NS ip addr add 127.0.0.1/8 dev lo
sudo ip netns exec $NS ip link set lo up

sudo ip link add $LINK type veth peer name $VETH
sudo ip link set $LINK up
sudo ip link set $VETH netns $NS up
sudo ip addr add $IP_NS dev $LINK
sudo ip netns exec $NS ip addr add $IP_HOST dev $VETH
sudo ip netns exec $NS ip route add default via $IP_GW dev $VETH
sudo nmcli connection reload

#IP address of namespace as seen from host: 10.200.1.2
#IP address of host as seen from namespace: 10.200.1.1

#IP_NS=192.168.1.50/24
#IP_HOST=192.168.1.51/24
#IP_GW=192.168.1.50



#iptable Rules

sudo iptables -t nat -A POSTROUTING -s $IP_MASK -o $IF -j MASQUERADE
sudo iptables -I FORWARD -i $LINK -o $IF -j ACCEPT
sudo iptables -I FORWARD -o $LINK -i $IF -j ACCEPT
sudo sysctl -q net.ipv4.ip_forward=1


#DNS
#vopono_core::network::dns_config > Setting namespace $NS DNS server to 8.8.8.8

#Exec
#NS=v_ns; sudo ip netns exec $NS sudo -u $USER bash


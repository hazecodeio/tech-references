

export NSy=nety
export NSn=netn
export LINKy=lnky
export LINKn=lnkn

export VETHy=vethy
export VETHn=vethn

export IF=wlp34s0

sudo ip netns add $NSy
sudo ip netns exec $NSy ip addr add 127.0.0.1/8 dev lo
sudo ip netns exec $NSy ip link set lo up

sudo ip netns add $NSn
sudo ip netns exec $NSn ip addr add 127.0.0.1/8 dev lo
sudo ip netns exec $NSn ip link set lo up


#IP address of namespace as seen from host: 10.200.1.2
#IP address of host as seen from namespace: 10.200.1.1

export IP_MASKy=10.200.1.0/24
export IP_HOSTy=10.200.1.2/24
export IP_NSy=10.200.1.1/24
export IP_GWy=10.200.1.2



export IP_MASKn=10.200.2.0/24
export IP_HOSTn=10.200.2.2/24
export IP_NSn=10.200.2.1/24
export IP_GWn=10.200.2.2

sudo ip link add $LINKy type veth peer name $VETHy
sudo ip link set $LINKy up
sudo ip link set $VETHy netns $NSy up
sudo ip addr add $IP_HOSTy dev $LINKy
sudo ip netns exec $NSy ip addr add $IP_NSy dev $VETHy
sudo ip netns exec $NSy ip route add default via $IP_GWy dev $VETHy
#sudo nmcli connection reload



sudo ip link add $LINKn type veth peer name $VETHn
sudo ip link set $LINKn up
sudo ip link set $VETHn netns $NSn up
sudo ip addr add $IP_HOSTn dev $LINKn
sudo ip netns exec $NSn ip addr add $IP_NSn dev $VETHn
sudo ip netns exec $NSn ip route add default via $IP_GWn dev $VETHn
#sudo nmcli connection reload




#iptable Rules

sudo iptables -t nat -A POSTROUTING -s $IP_MASKy -o $IF -j MASQUERADE
sudo iptables -I FORWARD -i $LINKy -o $IF -j ACCEPT
sudo iptables -I FORWARD -o $LINKy -i $IF -j ACCEPT
sudo sysctl -q net.ipv4.ip_forward=1

sudo iptables -t nat -A POSTROUTING -s $IP_MASKn -o $IF -j MASQUERADE
sudo iptables -I FORWARD -i $LINKn -o $IF -j ACCEPT
sudo iptables -I FORWARD -o $LINKn -i $IF -j ACCEPT
sudo sysctl -q net.ipv4.ip_forward=1

sudo nmcli connection reload

#DNS
#vopono_core::network::dns_config > Setting namespace $NS DNS server to 8.8.8.8

#Exec
#NSy=nety; sudo ip netns exec $NSy sudo -u $USER bash
#NSn=nety; sudo ip netns exec $NSn sudo -u $USER bash


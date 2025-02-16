#
export IF=wlp34s0
export vIF=wlan0_ns
export NS=ns0

sudo ip netns add $NS
sudo ip link add $vIF link $IF netns $NS type ipvlan mode l2

sudo ip netns exec $NS ip link set lo up
sudo ip netns exec $NS ip link set $vIF up


sudo ip netns exec $NS ip addr add 192.168.1.15/24 dev $vIF
sudo ip netns exec $NS ip route add default via 192.168.1.1 dev $vIF

sudo nmcli connection reload

#NS=ns0; sudo ip netns exec $NS sudo -u haze bash
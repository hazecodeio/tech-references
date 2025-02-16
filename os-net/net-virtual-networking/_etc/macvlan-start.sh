#NOTE: Macvlans are not built to work on wireless interfaces
export IF=wlp34s0
export vIF=macvlan0
export NS=ns0

sudo ip netns add $NS
sudo ip link add $vIF link $IF type macvlan mode bridge
#sudo ip link set address 00:11:22:33:44:55 dev $vIF
sudo ip link set dev $vIF up
sudo ip link set $vIF netns $NS


sudo ip netns exec $NS ip link set lo up
sudo ip netns exec $NS ip link set $vIF up

sudo ip netns exec $NS ip addr add 192.168.1.15/24 dev $vIF
sudo ip netns exec $NS ip route add default via 192.168.1.1 dev $vIF

sudo nmcli connection reload

#NS=ns0; sudo ip netns exec $NS sudo -u haze bash
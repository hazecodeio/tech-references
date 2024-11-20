
#Appending to existing NetworkManager config file: /etc/NetworkManager/conf.d/unmanaged.conf

export NS=v_ns
export LINK=v_lnk
export VETH=v_eth
export IF=wlp34s0

export IP_MASK=10.200.1.0/24
export IP_NS=10.200.1.1/24
export IP_HOST=10.200.1.2/24
export IP_GW=10.200.1.1



sudo ip link delete $LINK

sudo ip netns delete $NS

sudo nmcli connection reload
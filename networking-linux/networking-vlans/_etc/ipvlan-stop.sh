
export IF=wlp34s0
export NS=ns0

sudo ip netns delete $NS

sudo nmcli connection reload
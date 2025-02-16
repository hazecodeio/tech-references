
#Appending to existing NetworkManager config file: /etc/NetworkManager/conf.d/unmanaged.conf

export NSy=nety
export NSn=netn
export LINKy=lnky
export LINKn=lnkn

export VETHy=vethy
export VETHn=vethn


sudo ip link delete $LINKy
sudo ip netns delete $NSy

sudo ip link delete $LINKn
sudo ip netns delete $NSn

sudo nmcli connection reload
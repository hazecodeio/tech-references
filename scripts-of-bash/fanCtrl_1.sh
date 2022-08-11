#!/bin/bash
### BEGIN INIT INFO
# Provides:          fanCtrl
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     1 2 3 4 5
# Default-Stop:      0 6
# Short-Description: Start fan control at boot time
# Description:       Enable service provided by fanCtrl.
### END INIT INFO

constMaxTemp=40
highest_core_temp=0
fanHI=false
fanLO=false

while [ 1 ]; do
	core_temperatures=($(sensors | grep "Core" | sed 's/.*:\s*+\(.*\)  .*(.*/\1/' | sed 's/[°C]//g' | sed 's/\.0//g'))

	for i in {0..11} ; do
		if [[ ${core_temperatures[i]} -gt $highest_core_temp ]]; then 
			highest_core_temp=${core_temperatures[i]}
		fi
	done

	if [[ $highest_core_temp -gt $constMaxTemp ]]; then
		if [[ "$fanHI" -eq false ]] ; then
			eval "i8kfan 2 2"
			fanHI=true
			fanLO=false
		fi
	else
		if [[ "$fanLO" -eq false ]] ; then
			eval "i8kfan 1 1"
			fanHI=false
			fanLO=true
		fi
	fi

	highest_core_temp=0;
	sleep 1;
done

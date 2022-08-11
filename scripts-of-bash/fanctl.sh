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

# Records the CPU temp and writes it to a temporary file.
tempCPU=0

constMaxTemp=40

fanHI=0
fanLO=0

while  [ 1 ] ; do
	var=($(sensors | grep "Core" | sed 's/.*:\s*+\(.*\)  .*(.*/\1/' | sed 's/[°C]//g' | sed 's/\.0//g'))

	for i in {0..11} ; do
		if [[ ${var[i]} -gt $tempCPU ]]; then 
			tempCPU=${var[i]}
		fi
	done

	if [[ $tempCPU -gt $constMaxTemp ]]; then
		if [[ "$fanHI" -eq 0 ]] ; then
			eval "i8kfan 2 2"
			fanHI=1
			fanLO=0
#			echo 'temp is high'
		fi
	else
		if [[ "$fanLO" -eq 0 ]] ; then
			eval "i8kfan 1 1"
			fanHI=0
			fanLO=1
#			echo 'temp is low'
		fi
	fi

	tempCPU=0;
	
sleep 1;
done

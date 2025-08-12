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

# Records the CPU temp and writes it to coreTemp temporary file.

TEMP_REF="${1}"
TEMP_UPPER=$((${TEMP_REF} + 1))
TEMP_LOWER=$((${TEMP_REF} + 1))

pwmFiles=$(find /sys/devices/platform/dell_smm_hwmon/hwmon/hwmon*/pwm* | jq -Rs)
echo $pwmFiles

switch=(-1)

while  [ true ] ; do

	coreTemp=$(sensors -j \
	                  | jq 'to_entries | .[]
	                            | select(.key|contains("core"))
	                            | .value | to_entries | .[]
	                            | select(.key|contains("Core"))
	                            | .value | to_entries | .[]
	                            |  select(.key|contains("input")) | .value' \
                    | jq -s 'max%100');

#	echo $coreTemp;

	if [ ${coreTemp} -gt ${TEMP_REF} ]; then
#      echo true;
      if [ ${switch} == 0 ] || [ ${switch} == -1 ]; then
          echo ${pwmFiles} | jq -r | xargs -i sudo su -c 'echo 255 > {}'
          switch=1
      fi
  elif [ $coreTemp -lt ${TEMP_UPPER} ]; then
#      echo false;
       if [ ${switch} == 1 ] || [ ${switch} == -1 ]; then
          echo $pwmFiles | jq -r | xargs -i sudo su -c 'echo 155 > {}'
          switch=0
       fi
  fi

sleep 10;
done

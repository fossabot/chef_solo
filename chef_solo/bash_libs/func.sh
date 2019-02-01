#!/bin/bash

function check_running_docker_containers {
  if [ -n "$(docker ps 2> /dev/null | grep nail )" ]; then
    echo -e "$red Active docker containers were found on your VM :$white\n $(docker ps -a | grep nail )\n\n$red Please stop them and restart TIGER installation $white"
    exit 1
  fi
}

function ubuntu_time_sync {
	systemctl enable ntp && \ 
	service ntp stop  && \
	service ntp start 
}

function rh_time_sync {
	/sbin/chkconfig ntpd on && \
	/sbin/service ntpd stop && \
	/sbin/service ntpd start
}

check_execution () {
  SETCOLOR_SUCCESS="echo -en \\033[1;32m"
  SETCOLOR_FAILURE="echo -en \\033[1;31m"
  SETCOLOR_NORMAL="echo -en \\033[0;39m"
  
  if [ $1 -eq 0 ]; then
      $SETCOLOR_SUCCESS
      echo -n $2
      echo  "$(tput hpa $(($(tput cols)/2)))$(tput cub 6)[OK]"
      $SETCOLOR_NORMAL
      
  else
      $SETCOLOR_FAILURE
      echo -n $2
      echo "$(tput hpa $(($(tput cols)/2)))$(tput cub 6)[FAIL]"
      echo -e "Something went wrong.\nSee the detailed log file ( $log_path ) or contact TIGER support team"
      $SETCOLOR_NORMAL
      exit 1
  fi
}
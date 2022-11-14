#!/bin/bash

local_ip=$(egrep -o 'fdaa.*:2' /etc/hosts)
sed -i "s/.*src.*/  src = \"$local_ip\"/g" /etc/telegraf/telegraf.conf

while true; do

  unset FLY_APP_IPS
  app_ips=($(dig AAAA +short "$FLY_APP_NAME.internal"|sort))

  count=0
  for ip in ${app_ips[@]}; do
      if [ ${app_ips[count]} != "$local_ip" ]; then
         FLY_APP_IPS+="\"${app_ips[count]}\""
         last=$(( count + 1 ))
         if [ $last -ne ${#app_ips[@]} ]; then
             FLY_APP_IPS+=,
         fi
      fi
      count=$(( $count + 1 ))
  done

  if [ "$FLY_APP_IPS" != "$FLY_APP_IPS_BK" ]; then
    echo "updating telegraf.conf"
    sed -i "s/.*urls.*/  urls = [$FLY_APP_IPS]/g" /etc/telegraf/telegraf.conf
  fi

  FLY_APP_IPS_BK=$FLY_APP_IPS
  sleep 60

done

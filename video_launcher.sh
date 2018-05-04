#!/bin/bash


DENIED_VIDEOS="denied_videos.csv"
LOGPATH=$1
if [ ! -e "$LOGPATH" ]
then
    touch $LOGPATH
fi
bash clean_videos.sh
satus="NO_SNAPSHOT"
while [ "$satus" = "NO_SNAPSHOT" ]
do
    curl -X GET http://127.0.0.1:8080/bqoepath/deploybestqoepath-test-all > /tmp/deploy-response-test.json 2> /dev/null
    satus=`cat /tmp/deploy-response-test.json | grep path | tr -d ' \t' | cut -d ":" -f 2 | cut -d',' -f 1 | sed s/\"//g`
    sleep 0.5
done

while read line
do
  host=`echo $line | cut -d';' -f 1`
  qv=`echo $line | cut -d';' -f 2`
  sleep_fraction=`echo $line | cut -d';' -f 3`
  
  destination=''
  destination_control=0

  curl -X GET http://127.0.0.1:8080/bqoepath/admweights-$host-all > /tmp/deploy-response-$host.json 2> /dev/null
  UUID=`uuid`

  destination=`cat /tmp/deploy-response-$host.json | grep dest_ip | tr -d ' \t' | cut -d ":" -f 2 | cut -d',' -f 1 | sed s/\"//g`

  if [ ! -n "$destination" ]
  then
    satus=`cat /tmp/deploy-response-$host.json | grep path | tr -d ' \t' | cut -d ":" -f 2 | cut -d',' -f 1 | sed s/\"//g`
    echo STATUS: $satus
    if [ "$satus" = "NO_ROUTE" ]
    then
        echo "SERVICE DENIED - NO SUCH ROUTE TO HOST $host"
        echo "`date +%s`;$host" >> $DENIED_VIDEOS
    fi
    continue
  else
    destination_name=`cat /tmp/deploy-response-$host.json | grep dst | tr -d ' \t' | cut -d ":" -f 2 | cut -d',' -f 1 | sed s/\"//g`
  fi
  echo "$host: Starting video $qv on $destination."

  if [ $qv -eq 0 ]
  then
      /home/mininet/mininet/util/m $host bash "player_wrapper.sh $destination $UUID $host $destination_name $LOGPATH muse 32 5" & #5 min
  elif [ $qv -eq 1 ]
  then
      /home/mininet/mininet/util/m $host bash "player_wrapper.sh $destination $UUID $host $destination_name $LOGPATH ny 119 20" & #20 min
  else
      /home/mininet/mininet/util/m $host bash "player_wrapper.sh $destination $UUID $host $destination_name $LOGPATH gt 241 40" & #40 min
  fi
  sleep $sleep_fraction
done < static_trace.csv

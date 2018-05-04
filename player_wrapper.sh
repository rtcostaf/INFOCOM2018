#!/bin/bash

SEGMENT_TIME=10
INTERVAL=10
i=1

BUFFER_LIMIT=60

DESTINATION=$1
UUID=$2
STALL_COUNT=0

STARTUP_TIME=0
STALL_LEN=0

SRCNAME=$3
DSTNAME=$4
LOGPATH=$5

VIDEOID=$6
SEGMENTS=$7
FACTOR=$8

rm -f /tmp/result-$UUID
BEG=`date +%s`
./cplayer $DESTINATION $VIDEOID $SEGMENTS $UUID 2&> /tmp/result-$UUID
END=`date +%s`
ELAPSED=`expr $END - $BEG`
	

rline=`cat /tmp/result-$UUID`

if [ -n "$rline" ]
then
    CEND=`echo $rline | cut -d';' -f 1`
    totaldiff=`echo $rline | cut -d';' -f 2`
    STARTUP_TIME=`echo $rline | cut -d';' -f 3`
    STALL_LEN=`echo $rline | cut -d';' -f 4`
    STALL_COUNT=`echo $rline | cut -d';' -f 5`
    echo "$CEND;$totaldiff;$STARTUP_TIME;$STALL_LEN;$STALL_COUNT;$DSTNAME;$SRCNAME;$UUID" >> $LOGPATH
fi

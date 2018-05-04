#/bin/bash

kill -9 $(ps auxf | grep muse | egrep -i 'bash|wget|cplayer' | grep -v grep | tr -s ' \t' | cut -d' ' -f 2 | tr -s '\n' ' ')
kill -9 $(ps auxf | grep ny | egrep -i 'bash|wget|cplayer' | grep -v grep | tr -s ' \t' | cut -d' ' -f 2 | tr -s '\n' ' ')
kill -9 $(ps auxf | grep gt | egrep -i 'bash|wget|cplayer' | grep -v grep | tr -s ' \t' | cut -d' ' -f 2 | tr -s '\n' ' ')
rm -f denied_videos.csv

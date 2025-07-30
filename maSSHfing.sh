#!/bin/sh

 masscan -p22 $1 -oG session.masshfing  --rate=1000
  if [[ $? -ne 0 ]] ; then
      exit 1
  fi
 grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' session.masshfing > openports.masshfing
 printf "[i] Parsing fingerprints while connecting to SSH servers...\n------------------------------------------------------------------------------------\n"
 echo
 rm session.masshfing 
 file=openports.masshfing
 while read line ; do
    python3 hassh/python/hassh.py -i eth0 -fp server -l json -o masshfing.log.json --print &
    ip=$( echo "$line" | cut -d ' ' -f 1 )
    sleep 2
    ssh -T -o StrictHostKeyChecking=yes admin@$ip
    printf  "\n------------------------------------------------------------------------------------\n"
 done < ${file}
 echo All done!
 COUNT=$(grep -c ".*" openports.masshfing)  
 echo -n "[i]" $COUNT "ENTRIES SAVED TO: masshfing.log.json"
 echo

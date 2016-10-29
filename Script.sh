#!/bin/bash
time="+%H"

while (($(date "$time") >= 8 &&  $(date "$time") <= 17))
 do
status=0
service=httpd

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
echo "Apache is running!!!"
((status++))
else
echo "Apache is not running, but i will start it!!!"
/etc/init.d/$service start
echo "service is down" | mail -s "Service $service is down" mirceastoica@yahoo.com;
((status++))
fi


open=`nmap -p 80 192.168.75.128 | grep "80" | grep open`
if [ -z "$open" ]; then
  echo "Connection to Devacademy.ro on port 80 failed"
  echo "Conection to Devacademy failed" | mail -s "Conection to Devacademy.ro on port 80 failed" mirceastoica@yahoo.com;
((status++))
else
  echo "Connection to Devacademy on port 80 succeeded"

fi

buffer=`curl -I  --stderr /dev/null http://192.168.75.128 | head -1 | cut -d' ' -f2`
if [ -z "$buffer" ]; 
  then 
    echo "Devacademy status is not 200" 
    echo "Devacademy status is not 200" | mail -s "Status of Devacademy" mirceastoica@yahoo.com;
((status++))  
else
    echo "Devacademy status is 200"
fi
content=`curl -s devacademy.ro | grep "Devacademy"`
if [ -z "$content" ] ;
then
    echo "Word Devacademy is not found on the page"
    echo "The word Devacademy is not found on the page" | mail -s "Devacademy is not found" mirceastoica@yahoo.com;
((status++))
else
    echo "Word Devacademy is found on the page"
fi

if (($status > 4))
then 
echo "The scripts has more than 4 errors" | mail -s "Script has errors" mirceastoica90@gmail.com
else
echo "Numarul total de erori:  $status"
fi
sleep 120
done

#!/bin/bash
id=$(cat params.json | jq -r ".id")
token=$(cat params.json | jq -r ".token")
cookie="_hjAbsoluteSessionInProgress=0; _ga=GA1.2.1018503512.1598782359; _gid=GA1.2.179758252.1601222331; _hjTLDTest=1; _hjid=12e9966c-7504-4dbf-a151-7ec96c101835"
time=$(cat params.json | jq -r ".time")
tstamp=$(date -jf "%Y-%m-%d %H:%M:%S" "$time" +%s)

now=$(date +%s)

tstampminusone=$((tstamp-3))

while [[ "$now" -lt "$tstampminusone" ]];
do now=$(date +%s)
echo $(date) >> log.txt
echo $(date)
sleep 0.5; done

i=0

while [[ "$i" -lt 100 ]];
do echo "===== Sending "'${i}'"st request =====" >> log.txt

resp=$(curl 'https://schalter.asvz.ch/tn-api/api/Lessons/'"${id}"'/enroll??t='"${tstamp}"'000' -XPOST -H 'Content-Type: application/json' -H 'Accept: application/json, text/plain, */*' -H 'Authorization: Bearer '"$token" -H 'Accept-Language: en-us' -H 'Accept-Encoding: gzip, deflate, br' -H 'Host: schalter.asvz.ch' -H 'Origin: https://schalter.asvz.ch' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15' -H 'Connection: keep-alive' -H 'Referer: https://schalter.asvz.ch/tn/lessons/'"${id}" -H 'Content-Length: 2' -H 'Cookie: _hjAbsoluteSessionInProgress=0; _ga=GA1.2.1018503512.1598782359; _gid=GA1.2.179758252.1601222331; _hjTLDTest=1; _hjid=12e9966c-7504-4dbf-a151-7ec96c101835' --data-binary '{}')

echo $resp >> log.txt 
echo $resp

data=$(echo ${resp} | jq -r ".data")

if [ "$data" != "null" ]
	then
	place= echo $data | jq -r ".placeNumber"
	if [ "$place" != "null"  ]
		then break
	fi
fi
	

sleep 0.1
i=$((i+1)); done



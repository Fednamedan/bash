#!/bin/bash
export LANG=ru_RU.UTF-8
export DISPLAY=:0
export TZ=UTC
cmd="/opt/1cv8t/x86_64/8.3.23.1865/1cv8t"
user="\u0410\u0434\u043c\u0438\u043d\u0438\u0441\u0442\u0440\u0430\u0442\u043e\u0440"
dbfile="/home/student/\u0414\u043e\u043a\u0443\u043c\u0435\u043d\u0442\u044b/InfoBase"
dbname="test"
dir_=$(dirname $0)
destination="${dir_}/backup__$(date +%Y-%m-%d-%H-%M-%S).dt"

keep="2" # minutes

current_unixtime=$(date +%s)
test_unixtime=$(($current_unixtime-$keep*60))

function backup(){
	${cmd} config /N "${user}" /F "${dbfile}" /D "${dbname}" /DumpIB "${destination}"
}

function rotate_backups(){

	for f in $(ls ${dir_}/*.dt);do
		datetime_from_file=$(echo ${f} | awk -F '__' {'print $2'} | awk -F '.' {'print $1'})
		#echo $datetime_from_file;
		#2023-12-24-22-01-02
		Y=$(echo ${datetime_from_file} | awk -F '-' {'print $1'})
		M=`echo ${datetime_from_file} | awk -F '-' {'print $2'}`
		D=$(echo ${datetime_from_file} | awk -F '-' {'print $3'})
		h=`echo ${datetime_from_file} | awk -F '-' {'print $4'}`
		m=`echo ${datetime_from_file} | awk -F '-' {'print $5'}`
		s=`echo ${datetime_from_file} | awk -F '-' {'print $6'}`

		unixtime_from_file=`date +%s --date="${Y}-${M}-${D} ${h}:${m}:${s}"`
		if [[ $unixtime_from_file -lt $test_unixtime ]]; then
			echo "delete file: ${f}"
			/bin/rm ${f}
		else
			echo "keep file: ${f}"
		fi
	done
}


backup
rotate_backups

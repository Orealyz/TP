#!/bin/bash

#IdCard

echo "Machine name : $(hostname)"
echo "OS $(source /etc/os-release ; echo $NAME) and kernel version is $(uname -r)"
echo "IP : $(ip a | grep -w inet | tr -s ' ' | tail -n 1 | cut -d' ' -f5)"
echo "RAM : $(free -h | grep Mem | tr -s ' ' | cut -d' ' -f4) memory available on $(free -h | grep Mem | tr -s ' ' | cut -d' ' -f2) total memory"
echo "Disque : $(df -h | grep '/$' | tr -s " " | cut -d " " -f 4) space left"
echo "Top 5 processes by RAM usage : "
ligne_ps=2
while [[ ${ligne_ps} -ne 7 ]]
do
  ps_nom="$(ps aux --sort=-%mem | tr -s ' ' | cut -d' ' -f11 | sed -n ${ligne_ps}p)"
  ps_ram="$(ps aux --sort=-%mem | tr -s ' ' | cut -d' ' -f4 | sed -n ${ligne_ps}p)"
  echo "  - $ps_nom (RAM utilisé : $ps_ram)"
  ligne_ps=$((ligne_ps + 1))
done
echo "Listening ports :"
while read ligne
do
  ss_port_num=$(echo ${ligne} | tr -s ' ' | cut -d' ' -f5 | cut -d':' -f2)
  ss_port_type=$(echo ${ligne} | tr -s ' ' | cut -d' ' -f1)
  ss_port_service=$(echo ${ligne} | tr -s ' ' | cut -d' ' -f7 | cut -d'"' -f2)
  echo "  - $ss_port_num $ss_port_type : $ss_port_service"
done <<< "$(sudo ss -lnp4H)"

curl https://cataas.com/cat --output cat 2> /dev/null
_file_extension="$(file cat | cut -d' ' -f2)"

if [[ "${_file_extension}" == PNG ]]
then
   _extension='.png'
elif [[ "${_file_extension}" == JPEG ]]
then
   _extension='.jpeg'
elif [[ "${_file_extension}" == GIF ]]
then
  _extension='.gif'
else
   echo"File type unknow"
   exit 1
fi
_file_name="cat"
_file="${_file_name}${_extension}"
mv "cat" "${_file}"
echo "Here is your random cat: ./${_file}"

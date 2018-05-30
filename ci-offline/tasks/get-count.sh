#!/bin/bash

main_app_exist=$(cf apps | grep "bg-" | grep "main" | wc -l)
main_instance_count=1
if [ $main_app_exist -eq 1 ]
then
 main_instance_count=$(cf apps | grep "bg-" | grep "main" | awk -F"/" '{print $2} ' |awk '{print $1}')
fi
echo $main_instance_count

for (( i=2 ;i < $main_instance_count ; i++ )) {
 cf scale bg-blue-cidemo -i $i
}


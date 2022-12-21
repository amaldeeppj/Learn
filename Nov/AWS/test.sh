#!bin/bash

subnet=("10.0.1.0/24" "10.0.2.0/24")

for each in ${subnet[*]}
do
    echo $each 
done

echo ${subnet[0]}




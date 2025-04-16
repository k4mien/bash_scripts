#!/bin/bash

min_year=2000
max_year=2025

min_files=5
max_files=30

min_size=3
max_size=15


echo -n "Wpisz liczbe katalogów do utworzenia: "
read clients
if ! [[ $clients =~ ^[1-9][0-9]*$ ]]; then
	exit 1
fi

for i in $(seq 1 $clients); do
	mkdir -p katalog$i
	num_of_years=$(($RANDOM%($max_year-$min_year+1)+1))
	years=($(shuf -i $min_year-$max_year -n $num_of_years))
	for j in $(seq 1 $num_of_years); do
		mkdir -p katalog$i/${years[j-1]}
		num_of_files=$(($RANDOM%($max_files-$min_files+1)+$min_files))
		for k in $(seq 1 $num_of_files); do
			file_size=$(($RANDOM%($max_size-$min_size+1)+$min_size))
			#dd if=/dev/zero of=katalog$i/${years[j-1]}/plik$k bs=1M count=$file_size status=none
			fallocate -l "${file_size}M" "katalog$i/${years[j-1]}/plik$k"
		done
	done
done	

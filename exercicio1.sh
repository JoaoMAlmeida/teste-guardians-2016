#!/bin/bash


# Bloco de variaveis
local_requests=0
remote_requests=0
local_average_time=0
remote_average_time=0
valid_requests=0
most_requested=""



# Contagem de requisicoes
for var in $(grep --binary-files=text ' - -' ./access_log | cut -d " " -f 1 ); do
	if [ $var == 'local' ]; then
		local_requests=$(($local_requests + 1))
	else
		remote_requests=$(($remote_requests + 1))
	fi
done

valid_requests=$(($local_requests + $remote_requests))



# Calculo de medias - locais
for hour in $(grep --binary-files=text 'local - -' ./access_log | cut -d ":" -f 2); do
	local_average_time=$(($local_average_time + 10#$hour))
done
local_average_time=$(($local_average_time / $local_requests))



# Calculo de medias - remotas
for hour in $(grep --binary-files=text 'remote - -' ./access_log | cut -d ":" -f 2); do
	remote_average_time=$(($remote_average_time + 10#$hour))
done
remote_average_time=$(($remote_average_time / $remote_requests))



# Verifica requisicoes mais feitas
if [ $local_requests -gt $remote_requests ]; then
	most_requested="Local"
else
	most_requested="Remote"
fi



# Visualizacao de valores
echo ""
echo "Requests:"
echo "Local - " $local_requests
echo "Remote - " $remote_requests
echo "Valid - " $valid_requests
echo ""
echo "Most Requested - " $most_requested
echo ""
echo "Most requested hours:"
echo "Local average - " $local_average_time"h"
echo "Remote average - " $remote_average_time"h"
echo ""

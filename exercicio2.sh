#!/bin/bash


# Bloco de variaveis #

process_list=$(mktemp)
bigest_CPU=0
lowest_CPU=200
bigest_MEM=0
lowest_MEM=200
bigest_CPUs='0'
lowest_CPUs='200'
bigest_MEMs='0'
lowest_MEMs='200'


# Bloco de funcoes #

# Funcao que calcula uso total da CPU
getTotalCPU()
{
sum=0
for value in $(awk '{print $3}' $process_list); do
	sum=$(echo "$sum + $value" | bc)
done
echo $sum
}


# Funcao que calcula uso total da MEM
getTotalMEM()
{
sum=0
for value in $(awk '{print $4}' $process_list); do
	sum=$(echo "$sum + $value" | bc)
done
echo $sum
}


# Funcao que verifica o maior valor de CPU em uma iteracao
getBigestCPU()
{
for value in $(awk '{print $3}' $process_list); do
	if [ $(echo "$bigest_CPU < $value" | bc) -eq 1 ]; then
		bigest_CPU=$value
	fi
done
echo $bigest_CPU
}


# Funcao que verifica o menor valor de CPU em uma iteracao
getLowestCPU()
{
for value in $(awk '{print $3}' $process_list); do
	if [ $(echo "$lowest_CPU > $value" | bc) -eq 1 ]; then
		lowest_CPU=$value
	fi
done
echo $lowest_CPU
}


# Funcao que verifica o maior valor de MEM em uma iteracao
getBigestMEM()
{
for value in $(awk '{print $4}' $process_list); do
	if [ $(echo "$bigest_MEM < $value" | bc) -eq 1 ]; then
		bigest_MEM=$value
	fi
done
echo $bigest_MEM
}


# Funcao que verifica o menor valor de MEM em uma iteracao
getLowestMEM()
{
for value in $(awk '{print $4}' $process_list); do
	if [ $(echo "$lowest_MEM > $value" | bc) -eq 1 ]; then
		lowest_MEM=$value
	fi
done
echo $lowest_MEM
}


# Funcao que verifica o maior valor de CPU - Total
getTotalBigestCPU()
{
compareN=$(echo $bigest_CPUs | cut -d" " -f1)
for position in $(seq 2 $num); do
	value=$(echo $bigest_CPUs | cut -d" " -f$position)
	if [ $(echo "$compareN < $value" | bc) -eq 1 ]; then
		compareN=$value
	fi
done
echo $compareN
}


# Funcao que verifica o menor valor de CPU - Total
getTotalLowestCPU()
{
compareN=$(echo $lowest_CPUs | cut -d" " -f1)
for position in $(seq 2 $num); do
	value=$(echo $lowest_CPUs | cut -d" " -f$position)
	if [ $(echo "$compareN > $value" | bc) -eq 1 ]; then
		compareN=$value
	fi
done
echo $compareN
}


# Funcao que verifica o maior valor de MEM - Total
getTotalBigestMEM()
{
compareN=$(echo $bigest_MEMs | cut -d" " -f1)
for position in $(seq 2 $num); do
	value=$(echo $bigest_MEMs | cut -d" " -f$position)
	if [ $(echo "$compareN < $value" | bc) -eq 1 ]; then
		compareN=$value
	fi
done
echo $compareN
}


# Funcao que verifica o menor valor de MEM - Total
getTotalLowestMEM()
{
compareN=$(echo $lowest_MEMs | cut -d" " -f1)
for position in $(seq 2 $num); do
	value=$(echo $lowest_MEMs | cut -d" " -f$position)
	if [ $(echo "$compareN > $value" | bc) -eq 1 ]; then
		compareN=$value
	fi
done
echo $compareN
}


# Funcao que verifica se o usuario existe
verifyUser()
{
count=$(ps -eo user | grep -c "^$p_user")
if [ $count -eq 0 ]; then
	exit 2
fi
}


# Bloco de execucao #

# Verifica se existe parametros.
if [ $# -eq 0 ]; then
	read num
	read seconds
	read p_user
elif [ $# -eq 3 ]; then
	num=$1
	seconds=$2
	p_user=$3
else
	exit 1
fi


# Verifica se algum valor eh menor ou igual a zero.
if [ $num -le 0 ] || [ $seconds -le 0 ]; then
	exit 1
fi


# Lista processos
for var in $(seq $num); do
	$(verifyUser)
	ps aux | grep "^$p_user" > $process_list
	echo ""
	echo "Interacao" $var  "- Total CPU:" $(getTotalCPU)
	echo "Interacao" $var  "- Total MEM:" $(getTotalMEM)
	echo ""
	echo "Interacao" $var "- Numero de processos:" $(wc -l $process_list | cut -d" " -f 1)
	echo ""
	bigest_CPUs="$bigest_CPUs "$(getBigestCPU)
	lowest_CPUs="$lowest_CPUs "$(getLowestCPU)
	bigest_MEMs="$bigest_MEMs "$(getBigestMEM)
	lowest_MEMs="$lowest_MEMs "$(getLowestMEM)
	sleep $seconds
done


# Retorna Maiores/Menores
echo "Maior CPU:" $(getTotalBigestCPU)
echo "Menor CPU:" $(getTotalLowestCPU)
echo ""
echo "Maior MEM:" $(getTotalBigestMEM)
echo "Menor MEM:" $(getTotalLowestMEM)
echo ""


rm $process_list

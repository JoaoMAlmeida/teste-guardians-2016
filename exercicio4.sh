#!/bin/bash


# Bloco de variaveis #


comando=''
trace_comandos=$(mktemp)
tempos=''




# Bloco de execucao #


# Ler comandos
while [ $# -ne 0 ]; do
	comando="$comando $1"
	shift
done
strace -T$comando 2> $trace_comandos


# Procura e imprime as chamadas com os maiores tempos
echo
echo "Chamadas:"
posi=1
for tempo in $(grep ">$T" $trace_comandos | rev | cut -d"<" -f 1 | cut -d">" -f 2 | rev | sort -r); do
	if [ $posi -gt 3 ]; then
		break
	fi
	grep "<$tempo>" $trace_comandos | head -n 1
	posi=$(($posi + 1))
done
echo


# Imprime a syscall mais chamada
syscall_mais_chamada=$(cat $trace_comandos | cut -d"(" -f 1 | sort | uniq -c | awk '{print $1,$2}' | sort -g -r | head -n 1)
echo "Syscall: $syscall_mais_chamada"
echo



rm $trace_comandos

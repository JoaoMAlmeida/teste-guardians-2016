#!bin/bash


temp=$(mktemp)


# Bloco de funcoes #


# Funcao que testa o exercicio para o aluno passados, respectivamente, nos parametros.
testEXSTU()
{
echo
echo "EXERCICIO_"$exercicio"_"$aluno":"
for file in $(ls | grep "^EXERCICIO_$exercicio" | grep ".in"); do
	counter=$(echo $file | cut -d"." -f 1 | cut -d"_" -f 3)
	echo "- SAIDA PARA ENTRADA" $counter":"
	(bash "EXERCICIO_"$exercicio"_"$aluno".sh" < $file) > $temp
	cat $temp
	echo
	echo "- DIFERENCA PARA A SAIDA ESPERADA:"
	diff $temp "EXERCICIO_"$exercicio"_"$counter".out"
	echo
done
echo "...."
echo
}



# Funcao que testa o exercicio passado para todos os alunos.
testEXALL()
{
echo
for student in $(ls | grep "^EXERCICIO_$exercicio" | grep ".sh"); do
	echo $(echo $student | cut -d"." -f 1)":"
	for file in $(ls | grep "^EXERCICIO_$exercicio" | grep ".in"); do 
		counter=$(echo $file | cut -d"_" -f 3 | cut -d"." -f 1)
		echo "- SAIDA PARA ENTRADA" $counter":"
		(bash $student < "EXERCICIO_"$exercicio"_"$counter".in") > $temp
		cat $temp
		echo
		echo "- DIFERENCA PARA A SAIDA ESPERADA:"
		diff $temp "EXERCICIO_"$exercicio"_"$counter".out"
		echo
	done
	echo "...."
	echo
done
students=$(ls | grep "^EXERCICIO_$exercicio" | grep ".sh" | cut -d"_" -f 3- | sort | uniq | wc -l)
echo "Quantidade de alunos testados:" $students
echo
}




# Funcao que testa todos os exercicio para todos os alunos
testALLALL()
{
echo
for exercise in $(ls | grep "^EXERCICIO_" | grep ".sh"); do
	counterE=$(echo $exercise | cut -d"_" -f 2)
	echo $(echo $exercise | cut -d"." -f 1)":"
	for file in $(ls | grep "^EXERCICIO_$counterE" | grep ".in"); do
		counterIn=$(echo $file | cut -d"_" -f 3 | cut -d"." -f 1)
		echo "- SAIDA PARA ENTRADA" $counterIn":"
		(bash $exercise < $file) > $temp
		cat $temp
		echo
		echo "- DIFERENCA PARA A SAIDA ESPERADA:"
		diff $temp "EXERCICIO_"$counterE"_"$counterIn".out"
		echo
	done
	echo "...."
	echo
done
students=$(ls | grep "^EXERCICIO_" | grep ".sh" | cut -d"_" -f 3- | sort | uniq | wc -l)
echo "Quantidade de alunos testados:" $students
echo
}




# Bloco de execucao #


# Verifica a entrada.
if [ $# -eq 2 ]; then   # 2 Parametros passados
	exercicio=$1
	aluno=$2
	testEXSTU
elif [ $# -eq 1 ]; then # 1 Parametro passado
	exercicio=$1
	testEXALL
else                    # Nenhum Parametro passado
	testALLALL
fi

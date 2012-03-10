#! /bin/bash

#Inicia los valores
i=1
ListaSala=(a e f et)
declare -a Pagina

# Me guarda cada pagina como una variable dentro
# de el array Pagina
nano ListaDePaginas
NumeroDePartes=$(wc -l < ListaDePaginas)
j=1
while read line
do 
    Pagina[$j]=$line
    j=$(($j+1))
done < ListaDePaginas
rm ListaDePaginas

# Bueno ya logro que lo haga en background pero necesito ayuda para hacer que 
# use la salida del ping pro para el revisar si esta encendida
while [ $i < $NumeroDePartes ]
do
    if consigue COMPUTADORA CONECTADA (log pingpro)
    then

	# No estoy seguro si esta bien usado el comando screen asi por favor revisenlo
	# Ademas no se si el se va a detener hasta que termine el la descarga o va a seguir con la iteracion
	# Por que lo ideal es que lo haga y siga con la iteracion hasta que consiga las N maquinas que esten
	# encendidas. 
	# En general la idea es que si son N paginas, el abra N terminales con screen 
	# (que trabajen en paralelo) y que ellas hagan el resto.
	# Otra cosa es que no se si yo declarando las variables aqui (tales como la variable $password
	# me la vaya a seguir guardando una vez que use screen
	
	screen -S $i -X stuff 'sshpass -p $password ssh COMPUTADORA CONECTADA 'wget -b --output-document= '"$i"' Pagina[$i]; exit' 
	sshpass -p $password scp COMPUTADORA CONECTADA:~/'"$i"' . ^M'
	$i=$(($i+1))
    fi
done
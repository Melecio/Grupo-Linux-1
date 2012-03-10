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

# Aqui es donde consigo un problema,
# como hacer las descargas simultaneas en las maquinas
# se me ocurre mandarlos a background pero no consigo
# la forma de que me avisen cuando terminen la descarga
while [ $i < $NumeroDePartes ]
do
    if consigue COMPUTADORA CONECTADA (log pingpro)
    then
	ssh COMPUTADORA CONECTADA 'wget Pagina[1]'
	$i=$(($i+1))
    fi
done
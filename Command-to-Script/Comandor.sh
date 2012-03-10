#! /bin/bash
# Script que corre comandos  

# Un loop que espera por la respuesta adecuada
until [[ $Respt = Crear  ||  $Respt = Viejo ]]
do
	echo "Desea crear una lista nueva o usar una existente? [Crear/Viejo] "
	read Respt
done

# Si no se especifica una lista, se crea en mitad del script 
if [ $Respt = Crear ] ; then
	echo "cree la lista de comandos" ; sleep 3
	nano "ListadeComandos"
	dir=$PWD"/ListadeComandos"
else
	echo "Especifique el documento"
	read dir
fi

function obtener_salas
{
    local _S="$1[*]"
    _S=(${!_S})

    if [ ${_S:-1} -eq 1 ] 2>>/dev/null ; then
	s[0]="a"
	s[1]="e"
	s[2]="f"
	s[3]="et"
    else
	if [ ${#_S} -eq 1 ] || [ ${#_S} -eq 2 ] ; then
	    s=($_S)
	    return 1
	fi
	for i in {0..3}; do
	    aux=$(echo $_S | cut -d":" -f$(($i+1)))
	    if [ ${aux:-1} = 1 ] ; then 
		return 1
	    else
		s[$i]=$aux
	    fi
	done
    fi
}

function obtener_rangos
{
    local rango_="$1[*]"
    rango_=(${!rango_})
    if [ ${#rango_} -le 5 ] ; then
	start=(${rango_//:*})
	end=(${rango_#*:})
	return 1
    fi
    if [ $rango_ ] ; then	
	for i in {0..3}; do	    echo
	    r=$(echo $rango_ | cut -d"/" -f$(($i+1)))
	    if [ ${r:-1} = 1 ] ; then 
		return 1
	    fi
	    start[$i]=$(echo $r | cut -d":" -f1)	
	    end[$i]=$(echo $r | cut -d":" -f2)
	done
    else	 
	start=1
	end=24
    fi
}

function validar_rangos
{
    local min="$1"
    min=(${!min})

    local max="$2"
    max=(${!max})

    if [ $min -lt 1 ] || [ $max -gt 24 ] ; then
	echo Verifique que los rangos introducidos sean validos
	exit 1
    fi

    if [ $min -gt $max ] ; then
	temp=$min
	min=$max
	max=$temp
    fi

    tmp=($min $max)

    return $tmp
}

function validar_salas
{
    local _S="$1[*]"
    _S=(${!_S})

    for s_ in ${_S[*]} ; do
	if [ $s_ != e ] && [ $s_ != a ] && [ $s_ != et ] && [ $s_ != f ]; then
	    echo Alguna sala invalida
	    exit 1
	fi
    done
}

# Declaracion de variables
declare -a s
declare -a start
declare -a end

# Tipico y odiado getopts
while getopts ":s:r:" opcion
do
    case $opcion in
        s ) salas="$OPTARG" ;;
        r ) rangos="$OPTARG" ;;
 	\?) echo "[-s a:e:f:et] [-r inicio:final/inicial1:final1/inicial2:final2/inicial3:final3] " ; exit ;;
    esac
done
shift $(($OPTIND -1))

obtener_salas "salas"
validar_salas "s"

#llamado a las funciones y verificacion de rangos
obtener_rangos "rangos"
# Validacion de rangos
old_long_start=${#start[@]}
if [ ${#s[@]} -gt ${#start[@]} ] ;  then
    for j in $(seq ${#start[@]} $((${#s[@]}-1))) ;  do
	start[$j]=1
	end[$j]=24
    done
fi
for i in $(seq 0 $(($old_long_start-1))) ; do
    validar_rangos "start[$i]" "end[$i]"
    tmp=$?
    start[$i]=${tmp[0]}
    end[$i]=${tmp[1]}
done

declare -i fk=0 # Arreglo mas importante!
# Itera por todas las pc's y les pasa los comandos linea por linea
for sala in ${s[*]}
do    
    for i in $(seq ${start[$fk]} ${end[$fk]}) 
    do
	if ping -c 1 $sala$i.ac.labf.usb.ve 2>>/dev/null >>/dev/null ; then 
	    while read line 
	    do
		eval cmd=$($line)
		ssh root@$sala$i.ac.labf.usb.ve `$cmd ; exit` 2>/dev/null 
	    done < $dir
	else
	    echo "$sala$i esta apagada"
	fi
    done
    fk=$fk+1
done

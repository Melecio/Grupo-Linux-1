#! /bin/bash
# Script que corre scripts

# Obtiene las salas picando $salas con cut
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
for i in {0..3}; do
aux=$(echo $_S | cut -d":" -f$(($i+1)))
if [ ${aux:-1} = 1 ] ; then
return 1
else
s[$i]=$aux
fi
done
fi
if [ ${s[0]} = ${s[1]} ] ; then
for i in $(seq 1 3)
do
unset s[$i]
done
fi
    
}

# Obtiene los rangos picando $Rango con cut
function obtener_rangos
{
    local rango_="$1[*]"
    rango_=(${!rango_})
    if [ $rango_ ] ; then
for i in {0..3}; do
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

# Declaracion de arreglos
declare -a s
declare -a start
declare -a end

while getopts ":s:r:" opcion # Tipico getopts
do
case $opcion in
        s ) salas="$OPTARG" ;;
        r ) rangos="$OPTARG" ;;
  \?) echo "[-s a:e:f:et] [-r inicio:final/inicial1:final1/inicial2:final2/inicial3:final3] " ; exit ;;
    esac
done
shift $(($OPTIND -1))

obtener_salas "salas"
declare -p s
# Se llaman a las funciones y verifican los arreglos
obtener_rangos "rangos"
declare -p start
declare -p end

declare -i fk=0
# Itera por todas las computadoras desaeadas,
# llevando primero el script con scp, dandole permiso
# se corre y luego se borra para no dejar rastro
for sala in ${s[*]}
do
for i in $(seq ${start[$fk]} ${end[$fk]})
    do
if ping -c 1 $sala$i.ac.labf.usb.ve 2>>/dev/null >>/dev/null ; then
scp $1 root@$sala$i.ac.labf.usb.ve:./
ssh root@$sala$i.ac.labf.usb.ve "chmod +x /root/$1 ; /root/$1 ; rm -rf /root/$1 ; exit"

else
echo "$sala$i esta apagada"
fi
done
fk=$fk+1
done

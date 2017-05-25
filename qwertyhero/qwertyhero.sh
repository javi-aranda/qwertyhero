#!/bin/bash
#-------------------------------------------------------------------------------------
#setup inicial
RUTA=`pwd`
SONG="$RUTA/songs/bhcops.txt"
SONAR="$RUTA/songs/bhcops.sh"
declare -A matrix
ncol=6
nrow=4 
nota=
#colores
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
#-------------------------------------------------------------------------------------
function carga { #gracias a fedorqui de stackoverflow
	for ((k = 0; k <= 10 ; k++)) do
    	echo -n "[ "
		for ((i = 0 ; i <= k; i++)); do echo -n -e "${GREEN}#${RED}#${BLUE}#${NC}"; done
		for ((j = i ; j <= 10 ; j++)); do echo -n "   "; done
		v=$((k * 10))
		echo -n " ] "
		echo -n "$v %" $'\r'
		sleep 0.075
	done
	sleep 3
	echo
}
#-------------------------------------------------------------------------------------
function reset {
	for ((i=1; i<=ncol;i++)) do
		for ((j=1;j<=nrow;j++)) do
			matrix[$i,$j]=" "
		done
	done
}
#-------------------------------------------------------------------------------------
function pintar {
	echo -e  "+-----+-----+-----+-----+-----+-----+" 
	echo -e  "|  ${GREEN}${matrix[1,4]}${NC}  |  ${RED}${matrix[2,4]}${NC}  |  ${YELLOW}${matrix[3,4]}${NC}  |  ${BLUE}${matrix[4,4]}${NC}  |  ${ORANGE}${matrix[5,4]}${NC}  |  ${PURPLE}${matrix[6,4]}${NC}  |"
	echo -e  "+-----+-----+-----+-----+-----+-----+" 
	echo -e  "|  ${GREEN}${matrix[1,3]}${NC}  |  ${RED}${matrix[2,3]}${NC}  |  ${YELLOW}${matrix[3,3]}${NC}  |  ${BLUE}${matrix[4,3]}${NC}  |  ${ORANGE}${matrix[5,3]}${NC}  |  ${PURPLE}${matrix[6,3]}${NC}  |"
	echo -e  "+-----+-----+-----+-----+-----+-----+"
	echo -e  "|  ${GREEN}${matrix[1,2]}${NC}  |  ${RED}${matrix[2,2]}${NC}  |  ${YELLOW}${matrix[3,2]}${NC}  |  ${BLUE}${matrix[4,2]}${NC}  |  ${ORANGE}${matrix[5,2]}${NC}  |  ${PURPLE}${matrix[6,2]}${NC}  |"
	echo -e  "+-----+-----+-----+-----+-----+-----+"
	echo -e  "|  ${GREEN}${matrix[1,1]} ${NC} |  ${RED}${matrix[2,1]}${NC}  |  ${YELLOW}${matrix[3,1]}${NC}  |  ${BLUE}${matrix[4,1]}${NC}  |  ${ORANGE}${matrix[5,1]}${NC}  |  ${PURPLE}${matrix[6,1]}${NC}  |"
	echo -e "+-----+-----+-----+-----+-----+-----+"
	echo -e "   ${GREEN}q${NC}     ${RED}w${NC}     ${YELLOW}e${NC}     ${BLUE}r${NC}     ${ORANGE}t${NC}     ${PURPLE}y${NC}   "
}
#-------------------------------------------------------------------------------------
#main game
function main {
    source $SONG #carga los arrays que componen la canción seleccionada
    puntos=0
    for ((in=0; in<=LONG; in++)) do
        for ((J=4; J>0; J--)) do
            matrix[${NOTAS[$in]},$J]="O"
            pintar
            if [ $J = 1 ]; then 
                read -N 1 -t 0.33 -s nota
                if [ "$nota" = "${TECLAS[$in]}" ]; then 
                    beep ${DURACIONES[$in]} ${FRECUENCIAS[$in]}
                    puntos=$(($puntos+50))
		else
			sleep 0.33 # si la nota no es correcta, hace la pausa igualmente para que no se descontrole
                fi
                nota= # eliminar el valor almacenado de la nota
            fi
            reset
            sleep 0.1
            clear
        done
    done
    reset
    pintar
    $SONAR
    echo ""
    echo ""
    echo "PUNTUACION: $puntos"
    echo "VERSION: beta 0.9c early access"
    sleep 4
    menu
}
#-------------------------------------------------------------------------------------
function menu {
    clear
    select o in "Nueva Partida" "Escoger Canción" "Salir"; do
        case $o in
            "Nueva Partida")
                main ;;
            "Escoger Canción")
                canciones ;;
            "Salir")
                break
        esac
    done
}
#-------------------------------------------------------------------------------------
function canciones {
    clear
    select c in "Beverly Hills Cops" "Imperial March" "Volver"; do
        case $c in
            "Beverly Hills Cops")
                SONG="$RUTA/songs/bhcops.txt" 
                SONAR="$RUTA/songs/bhcops.sh" ;;
            "Imperial March")
                SONG="$RUTA/songs/imperial.txt"
                SONAR="$RUTA/songs/imperial.sh" ;;
            "Volver")
                menu ;;
        esac
    done
}
#-------------------------------------------------------------------------------------
clear
carga
menu
reset


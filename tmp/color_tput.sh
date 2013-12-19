#!/bin/bash

VREV=`tput rev`     # Reverso
VNOR=`tput sgr0`    # Normal
VPIS=`tput blink`   # Sublinhado
VBRI=`tput bold`    # Escuro
FVMO=`tput setab 1` # Fundo vermelho
CVMO=$(tput setaf 1) # Caracter Vermelho
#CVMO=`tput setaf 1` # Caracter Vermelho



echo "${VREV} REVERSO ${VNOR}"
echo "${VPIS} PISCANTE ${VNOR}"
echo "${VREV}${VPIS} REV E PISCANTE ${VNOR}"
echo "${FVMO} VERMELHO ${VNOR}"
echo "${VREV}${CVMO}${VBRI} VERMELHO ${VNOR}"

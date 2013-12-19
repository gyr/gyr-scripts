#!/bin/sh
#
# Metodo POG basico para implementar a classica helice ASCII.
#
# Este metodo pode ser utilizado para incrementar scripts que realizam operacoes
# longas e que nao retornam informacoes durante esse tempo!
#
# Sandro Marcell <sandro_marcell@yahoo.com.br> Boa Vista, Roraima - 18/12/2008
#
# Mais detalhes: 'man ascii'
#
# POG = 'Programacao Orientada a Gambiarras' =)
PATH="/bin:/usr/bin:/usr/local/bin"

# I - Executa-se o comando desejado em background:
sleep 10 > /dev/null 2>&1 &

# Funcao responsavel por implementar a helice:
mostraHelice()
{
    # Cursor invisivel (opcional!):
    tput civis

    # II - Checar se o comando em background ainda esta em execucao:
    while [ -d /proc/$! ]; do
        # III - Monta-se a helice:
        for i in / - \\ \|; do
            # Posicionamento dos caracteres
            printf "\033[1D$i"
            # P.S.: O escape '\033[1D' move o cursor uma posicao para esquerda!
            sleep .1
        done
    done
    tput cnorm
}

# Resultado na tela
printf "Aguarde...\040\040" ; mostraHelice
printf "\033[1Dok\012Fim do processo em background\012"
# Fim

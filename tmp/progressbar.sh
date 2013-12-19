#!/bin/bash
# progressbar
#
# INFORMAÇÕES: www.shellscripts.com.br/script/progressbar
# NASCIMENTO : 23 de outubro de 2008
# AUTORES    : Roger Pereira Boff < rogerboff (@) gmail com>
# DESCRIÇÃO  : Função para geração de barra de progresso.
# LICENÇA    : GPL v2
# CHANGELOG  : www.shellscripts.com.br/script/progressbar/changelog
# VERSÂO     : 0.8.9
#
##############################################################################
# Este script é baseado no script gauge.sh de Aurélio Marinho Jargas
##############################################################################
# Habilitado o modo restrito de saída para qualquer comando que retorne qual-
# quer valor diferente de "0"
set -e

# Função para geração de barra de progresso.
#
# Exemplo:
#   [#########################.........................]  50%
#   Registro(s) processado(s): 50 de 100."
#
# Exemplo de uso:
#   ProgressBar "TotalDeRegistro"
ProgressBar()
{
    # Verifica se a barra de progresso já foi criada.
    if [ -z "$PBAR" ];
    then

        # Total de registros a serem processados.
        PBTOTAL="$1"

        # Tamanho da string $PBTOTAL
        PBTOTALTAM="${#PBTOTAL}"

        # String com espaço reservado para 1.000.000.000 de registros.
        PBSTR="           de $PBTOTAL."

        # Cria a barra de progresso e o total de registros processados.
        echo "[..................................................]    %"
        echo "Registro(s) processado(s): ${PBSTR:$((10-$PBTOTALTAM))}"

        # Move o cursor para a coluna 59 e  2 linhas acima..
        echo -en "\033[59G\033[2A"

        # Seta que a barra de progresso já foi criada.
        PBAR="true"

    fi

    ######################### Imprime a porcentagem no final da barra ###########################################################

    # Adiciona 1 registro processado.
    PBREG=$((PBREG+1))

    # Calcula a porcentagem de registros processados
    PBPORC=$((PBREG*100/PBTOTAL))

    # Move o cursor para a coluna 56 da barra de progresso.
    echo -en "\033[$((57-${#PBPORC}))G$PBPORC\033[59G"

    ######################### Imprime o andamento na barra de progresso #########################################################

    # Recupera a posição anterior da barra de progresso.
    PBBARPOSANT="${PBBARPOS:-1}"

    # Calcula a posição na barra de progresso.
    PBBARPOS=$((PBPORC/2+1))

    # Verifica se a posição é igual a "1".
    if [ "$PBBARPOS" = "1" ]; then PBBARPOS=$((PBBARPOS+1)); fi

    # Utilizado "for" para imprimir a barra nas possiveis lacunas geradas.
    for PBBARPOSFOR in $(seq $((PBBARPOSANT+1)) $PBBARPOS)
    do

        # Imprime o movimento na barra de progresso.
        echo -en "\033[${PBBARPOSFOR}G#"

    done

    # Move o cursor para depois do sinal de porcentagem.
    echo -en ""

    ######################### Imprime o total de registros ######################################################################

    # Calcula a posição do cursor para o registro.
    PBREGPOS=$((28+$PBTOTALTAM-${#PBREG}))

    # Move o cursor para a coluna 28.
    echo -en "\033[1B\033[${PBREGPOS}G$PBREG\033[59G\033[1A"

    ######################## Finaliza com quebra de linha #######################################################################

    # Verifica se é o ultimo registro a ser processado.
    if [ "$PBTOTAL" = "$PBREG" ];
    then

        # Move o cursor para 1 linha abaixo
        echo -en "\033[1B"

        # Quebra a linha para que linha de comando não fique no final da barra de progresso.
        echo ""

    fi
}

ProgressBar 100 1 2 3 4 5 6 7 8 9 0

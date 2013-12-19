#!/bin/bash

FILE_NAME="${HOME}/teste.123"
BKP_DIR="${HOME}/"
BKP_EXT=".bkp"

if [ ! -e ${FILE_NAME} ]; then
    echo "File not found: ${FILE_NAME}"
    exit 1
fi

sed -i${BKP_EXT} '
# procurar por # www e substituir por www
s/^#\s*www/www/
t naoinserirwww
#inserir www caso nao encontre # www
$ a www
:naoinserirwww
# trocar aaa por bbb
s/aaa/bbb/
# apagar xxx
/xxx/d
# procurar por # zzz e substituir por zzz
s/^#\s*zzz/zzz/
t naoinserirzzz
#inserir zzz caso nao encontre # zzz
$ a yyy
:naoinserirzzz
# na linha que tenha ccc trocar o 111 por 222
/ccc/s/111/222/
' ${FILE_NAME}

mv ${FILE_NAME}${BKP_EXT} ${BKP_DIR}

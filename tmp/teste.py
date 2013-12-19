#!/usr/bin/env python

dic = {
    'k1': [ 'v1', 'v2', ],
    'k2': [ 'v3', 'v4', ],
    'k3': [ 'v5', 'v6', ],
}

l = list()

for chave, valor in dic.items():
    if chave == 'k1' \
            or chave == 'k3':
        for elem in valor:
            l.append(elem)

for elem in l:
    print elem

del dic['k2']
print dic

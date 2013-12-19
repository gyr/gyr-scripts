#!/usr/bin/env python
# coding: utf-8

import hashlib

def calc_hash():
    print ('''
    1) MD5
    2) SHA1
    3) SHA224
    4) SHA256
    5) SHA384
    6) SHA512
    7) CONTINUE
    8) SAIR
    : ''')

    cont = '7'
    while cont == '7':
        sel = raw_input('Digite o numero referente a criptografia \n')
        val = raw_input('Digite a string a ser criptografada \n')
        if   sel == '1':
            result = hashlib.md5(val).hexdigest()

        elif sel == '2':
            result = hashlib.sha1(val).hexdigest()

        elif sel == '3':
            result = hashlib.sha224(val).hexdigest()

        elif sel == '4':
            result = hashlib.sha256(val).hexdigest()

        elif sel == '5':
            result = hashlib.sha384(val).hexdigest()

        elif sel == '6':
            result = hashlib.sha512(val).hexdigest()

        elif sel == '7':
            calc_hash()

        elif sel == '8':
            exit

        print result
        cont = raw_input('Deseja continuar? \n')

if __name__ == "__main__":
    calc_hash()

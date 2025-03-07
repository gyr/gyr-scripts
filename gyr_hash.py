#!/usr/bin/env python3
# coding: utf-8

import hashlib
import sys


def menu() -> str:
    """Displays the menu and returns the user's choice."""
    print('''
    1) MD5
    2) SHA1
    3) SHA224
    4) SHA256
    5) SHA384
    6) SHA512
    7) SAIR
    ''')
    return input('Digite o numero referente a criptografia: ')


def calc_hash(hash_option: str) -> None:
    """Calculates and prints the hash based on the user's choice."""
    hash_options = {
        '1': lambda text: print(hashlib.md5(text.encode()).hexdigest()),
        '2': lambda text: print(hashlib.sha1(text.encode()).hexdigest()),
        '3': lambda text: print(hashlib.sha224(text.encode()).hexdigest()),
        '4': lambda text: print(hashlib.sha256(text.encode()).hexdigest()),
        '5': lambda text: print(hashlib.sha384(text.encode()).hexdigest()),
        '6': lambda text: print(hashlib.sha512(text.encode()).hexdigest()),
    }

    action = hash_options.get(hash_option)
    if action:
        text: str = input('Digite a string a ser criptografada: \n')
        action(text)
    else:
        sys.exit()


def main() -> None:
    """Main function to run the program."""
    running: bool = True
    while running:
        hash_option: str = menu()
        if hash_option == '7':
            running = False

        else:
            calc_hash(hash_option)


if __name__ == "__main__":
    main()

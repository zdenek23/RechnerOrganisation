#! /bin/bash

echo "b1.asm"

python atoyasm.py -s -p asm/b1.asm > toy/b1.toy

cat toy/b1.toy
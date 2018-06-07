#! /bin/bash

echo "c7.asm"

python atoyasm.py -s -p asm/c7.asm > toy/c7.toy

cat toy/c7.toy

echo "c7.toy"

python toy1.py -full toy/c7.toy testbed/toy_test_inputs/toy_input_rpn6.txt > tmp_files/toy_protocol.txt
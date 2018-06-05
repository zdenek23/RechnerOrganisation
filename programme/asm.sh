#! /bin/bash

echo "c0.asm"

python atoyasm.py -s -p asm/c0.asm > toy/c0.toy

cat toy/c0.toy

echo "c0.toy"

python toy1.py -full toy/c0.toy testbed/toy_test_inputs/toy_input_rpn6.txt > tmp_files/toy_protocol.txt
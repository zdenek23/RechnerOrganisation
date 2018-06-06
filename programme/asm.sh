#! /bin/bash

echo "c3.asm"

python atoyasm.py -s -p asm/c3.asm > toy/c3.toy

cat toy/c3.toy

echo "c3.toy"

python toy1.py -full toy/c3.toy testbed/toy_test_inputs/toy_input_rpn6.txt > tmp_files/toy_protocol.txt
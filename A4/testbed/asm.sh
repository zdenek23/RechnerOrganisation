#! /bin/bash

echo "d0.asm"

python atoyasm.py -s -p asm/d0.asm > toy/d0.toy

echo "d0.toy with test_input_rpn0.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn0.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn0.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

####################################################################

echo "d0.toy with test_input_rpn0m.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn0m.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn0m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################

echo "d0.toy with test_input_rpn1.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn1.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn1.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################

echo "d0.toy with test_input_rpn1m.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn1m.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn1m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################

echo "d0.toy with test_input_rpn2.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn2.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn2.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################

echo "d0.toy with test_input_rpn2m.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn2m.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn2m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################

echo "d0.toy with test_input_rpn3.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn3.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn3.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################
echo "d0.toy with test_input_rpn3m.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn3m.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn3m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################
echo "d0.toy with test_input_rpn4.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn4.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn4.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################
echo "d0.toy with test_input_rpn4m.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn4m.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn4m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################
echo "d0.toy with test_input_rpn5.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn5.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn5.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

#####################################################################
echo "d0.toy with test_input_rpn5m.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn5m.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn5m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "d0.toy with test_input_rpn6.txt"

python toy1.py -full toy/d0.toy testbed/toy_test_inputs/toy_input_rpn6.txt > tmp_files/toy_protocol.txt

tail -1 tmp_files/toy_protocol.txt > tmp_files/toy_out.txt

diff -q tmp_files/toy_out.txt testbed/toy_test_inputs/corr_out/corr_out_rpn6.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
      cat result.txt
    else
      tput setaf 2; echo "CORRECT"
    fi
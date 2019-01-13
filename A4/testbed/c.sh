#! /bin/bash

echo "a16.c"
gcc -o C/a16 a16.c

echo "a16.c with test_input_rpn0.txt" 
./a16 < testbed/test_inputs/input_rpn0.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn0.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn0m.txt" 
./a16 < testbed/test_inputs/input_rpn0m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn0m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn1.txt" 
./a16 < testbed/test_inputs/input_rpn1.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn1.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn1m.txt" 
./a16 < testbed/test_inputs/input_rpn1m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn1m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn2.txt" 
./a16 < testbed/test_inputs/input_rpn2.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn2.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn2m.txt" 
./a16 < testbed/test_inputs/input_rpn2m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn2m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn3.txt" 
./a16 < testbed/test_inputs/input_rpn3.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn3.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn3m.txt" 
./a16 < testbed/test_inputs/input_rpn3m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn3m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn4.txt" 
./a16 < testbed/test_inputs/input_rpn4.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn4.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn4m.txt" 
./a16 < testbed/test_inputs/input_rpn4m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn4m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn5.txt" 
./a16 < testbed/test_inputs/input_rpn5.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn5.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi

echo "a16.c with test_input_rpn5m.txt" 
./a16 < testbed/test_inputs/input_rpn5m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn5m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      tput setaf 1; echo "ERROR"
    else
      tput setaf 2; echo "CORRECT"
    fi
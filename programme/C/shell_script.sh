#! /bin/bash

echo "a3.c"
gcc -o a3 a3.c

echo "a3.c with test_input_rpn0.txt" 
./a3 < testbed/test_inputs/input_rpn0.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn0.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn0m.txt" 
./a3 < testbed/test_inputs/input_rpn0m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn0m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn1.txt" 
./a3 < testbed/test_inputs/input_rpn1.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn1.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn1m.txt" 
./a3 < testbed/test_inputs/input_rpn1m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn1m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn2.txt" 
./a3 < testbed/test_inputs/input_rpn2.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn2.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn2m.txt" 
./a3 < testbed/test_inputs/input_rpn2m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn2m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn3.txt" 
./a3 < testbed/test_inputs/input_rpn3.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn3.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn3m.txt" 
./a3 < testbed/test_inputs/input_rpn3m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn3m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn4.txt" 
./a3 < testbed/test_inputs/input_rpn4.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn4.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn4m.txt" 
./a3 < testbed/test_inputs/input_rpn4m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn4m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn5.txt" 
./a3 < testbed/test_inputs/input_rpn5.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn5.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi

echo "a3.c with test_input_rpn5m.txt" 
./a3 < testbed/test_inputs/input_rpn5m.txt > testbed/test_out.txt
    
diff -q testbed/test_out.txt testbed/expected_outputs/expected_output_rpn5m.txt > tmp_files/result.txt
    
if [[ -s tmp_files/result.txt ]];
    then
      echo "ERROR"
    else
      echo "CORRECT"
    fi
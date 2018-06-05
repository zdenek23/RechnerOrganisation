#!/usr/bin/env
##################################################
# Version 27 March 2017
##################################################


##################################################
# KC Posch, 2015
#
# "toy1.py" is a simulator of the TOY computer.
#
# The TOY computer is a 16-bit computer and 
# comes from the course Introduction to 
# Computer Science" from Princeton University.
# (introcs.cs.princeton.edu/xtoy)
#
# The TOY computer serves as the model computer
# within the course Computer Organisation at
# Graz University of Technology.
#
# This Python simulator simulates the 
# original TOY found in the
# Java simulator (Visual X-TOY).
# 
# TOY is a 16-bit computer. Its main memory
# has 256 locations, each holding a 16-bit value.
#
# The TOY CPU has a program counter (PC), 
# an instruction register (IR), and 16 registers
# R0...RF for holding data. The register R0
# has always the constant value 0.
# 
# Each TOY instruction consists of 16 bits.
# The top-most 4 bits of each instruction define
# the instruction type.
#
##################################################
# 
# Instruction formats of the original TOY:
#
#             | .... | .... | .... | .... |
#  Format 1:  |  op  |  d   |  s   |  t   |
#  Format 2:  |  op  |  d   |     imm     |
#
#
# ARITHMETIC and LOGICAL operations
#    1: add            R[d] <- R[s] + R[t]
#    2: subtract       R[d] <- R[s] - R[t]
#    3: and            R[d] <- R[s] & R[t]
#    4: xor            R[d] <- R[s] ^ R[t]
#    5: shift left     R[d] <- R[s] << R[t]
#    6: shift right    R[d] <- R[s] >> R[t]
#
# TRANSFER between registers and memory
#    7: load immediate R[d] <- imm
#    8: load           R[d] <- mem[imm]
#    9: store          mem[imm] <- R[d]
#    A: load indirect  R[d] <- mem[R[t]]
#    B: store indirect mem[R[t]] <- R[d]
#
# CONTROL
#    0: halt           halt
#    C: branch zero    if (R[d] == 0) pc <- imm
#    D: branch pos.    if (R[d] > 0) pc <- imm
#    E: jump register  pc <- R[d]
#    F: jump and link  R[d] <- pc; pc <- imm
#
#
# R[0] always reads 0.
# Loads from mem[FF] come from stdin.
# Stores to mem[FF] go to stdout.
#
##################################################

from array import *
import sys
import os
import re

##################################################
# main memory
# initialized with all zeroes.
##################################################
mem = array('i', [])
for i in range(256):
	mem.append(0);
	
##################################################
# set memory location 0xFE to 1: 
# emulates that the "input control register" is 1.
# with this trick it is possible to 
# execute also polling loops which check whether
# the control register (mapped to 0xFE) has 
# been set.
mem[0xFE] = 1
##################################################


##################################################
# 16 CPU registers
# initialized with all zeroes	
##################################################
R = array('i', [])
for i in range(16):
	R.append(0)	

##################################################
# stdout:
##################################################
stdout =array('I', [])

##################################################
# stdin:
##################################################
stdin =array('I', [])
	
# initialize index for stdin
stdin_index = 0

instruction_counter = 0
		
###################################################
# check arguments provided by user
##################################################
def check_mode_and_files():
	if len(sys.argv) < 3:
		print_usage()
		
	global single_step
	global mem_range
	global quiet_mode
	global silent_mode
	global do_print

	single_step = 0
	mem_range = 16
	quiet_mode = 0
	silent_mode = 0
	do_print = 1

	# check simulation mode
	if str(sys.argv[1]) == "-step":
		single_step = 1	
	elif str(sys.argv[1]) == "-short":
		mem_range = 2
	elif str(sys.argv[1]) == "-20":
	    mem_range = 2
	elif str(sys.argv[1]) == "-40":
	    mem_range = 4
	elif str(sys.argv[1]) == "-60":
	    mem_range = 6
	elif str(sys.argv[1]) == "-quiet":
		quiet_mode = 1
		do_print = 0
	elif str(sys.argv[1]) == "-silent":
		silent_mode = 1
		do_print = 0
	elif str(sys.argv[1]) != "-full":	 
		print_usage()
	
	# check whether file with machine code exists
	# check each line in file for correct format
	# if all OK:
	#   fill memory with contents
	lineno = 0
	if os.path.isfile(str(sys.argv[2])):
		f = open( str(sys.argv[2]), "r" )
		for line in f:
			lineno = lineno + 1
			l = line.split(";")	# remove comment
			l = l[0].split(":")
			if len(l) != 2:
				print "File does not have proper format: " + str(sys.argv[2])
				print "Found corrupt code in line number " + str(lineno) + ": " + line.rstrip()
				print "Missing colon!"
				f.close()
				sys.exit()
	
			if not re.search(r"[0-9A-F][0-9A-F]", l[0]):
				print "File does not have proper format: " + str(sys.argv[2])
				print "Found corrupt code in line number: " + str(lineno) + ": " + line.rstrip()
				print "Check address!"
				f.close()
				sys.exit()
			
			if not re.search(r"[0-9A-F][0-9A-F][0-9A-F][0-9A-F]", l[1]):
				print "File does not have proper format: " + str(sys.argv[2])
				print "Found corrupt code in line number: " + str(lineno) + ": " + line.rstrip()
				print "Check format of machine instruction!"
				f.close()
				sys.exit()
	
			mem[int(l[0].rstrip(), 16)] = int(l[1].rstrip(), 16)
		f.close()
	else:
		print "File not found: " + str(sys.argv[2])
		sys.exit()

	# stdin: fill array with contents
	#
	# first check whether file exists
	# then check each line for proper format
	# if correct: append to array "stdin"
	if len(sys.argv) == 4:
		if os.path.isfile(str(sys.argv[3])):
			f = open(str(sys.argv[3]), "r" )
			for line in f:
				line = line.upper()
				if not re.search(r"[0-9A-F][0-9A-F][0-9A-F][0-9A-F]", line):
					print "File for standard input does not have proper format: " + str(sys.argv[2])
					print "Found corrupt value in line number: " + str(lineno) + ": " + line.rstrip()
					print "Check format! Needs to be 4 hexadecimal digits!"
					f.close()
					sys.exit()
				
				stdin.append(int(line, 16))
			f.close()
		else:
			print "File for standard input not found: " + str(sys.argv[3])
			sys.exit()
	

###################################################
def print_stdin_contents():
	print "STDIN: "
	for i in range(len(stdin)):
		print format(stdin[i], '04x'),

###################################################
def print_stdout_contents():
	print "STDOUT: "
	for i in range(len(stdout)-1):
		print format(stdout[i], '04x'),
	if (len(stdout) != 0):
		print format(stdout[len(stdout)-1], '04x')
	
###################################################
def write_stdout_contents_to_file():
	f = open( "stdout", "w" )
	for i in range(len(stdout)):
		f.write(format(stdout[i], '04x')),
		f.write("  "),
	f.write("\n")
	f.close()

###################################################
def print_memory_contents(mem_range):
	print "MEM: "

	for j in range(mem_range):
		for i in range(16):
			if (mem[16*j+i] < 0):
				mem_i = mem[16*j+i] & 0xFFFFFFFF;  # pseudo-cast to unsigned
			else:
				mem_i = mem[16*j+i];
		
			if (mem[16*j+i] < 0):	
				mem_str = str(format(mem_i, '04X'))
				mem_str_toprint = mem_str[4:]
			else:
				mem_str_toprint = str(format(mem_i, '04X'))
		
			if ((i != 15) & (i != 7)):
				print format(16*j+i, '02X') + ":" + mem_str_toprint + "  ",
			elif (i==7):
				print format(16*j+7, '02X') + ":" + mem_str_toprint
			else:
				print format(16*j+15, '02X') + ":" + mem_str_toprint

###################################################
def print_register_contents():
	print "REG: "
	for i in range(16):
		if (R[i] < 0):
			Ri = R[i] & 0xFFFFFFFF;  # pseudo-cast to unsigned
		else:
			Ri = R[i];
		if (R[i] < 0):	
			Rstr = str(format(Ri, '04X'))
			Rstr_toprint = Rstr[4:]
		else:
			Rstr_toprint = str(format(Ri, '04X'))
			
		if ((i != 15) & (i != 7)):
			print "R" + str(format(i, '01X')) + ":" + Rstr_toprint + "  ",
		else:
			print "R" + str(format(i, '01X')) + ":" + Rstr_toprint

###################################################
def initial_printout(mem_range):
	print " "
	print " "
	print "*****************************************************************************"
	print "*TOY ************************************************************************"
	print "*****************************************************************************"
	print " "
	print "============================================================================="
	print "Initial state: =============================================================="
	print "============================================================================="
	print_register_contents()
	print "============================================================================="
	print_memory_contents(mem_range)
	print "============================================================================="
	print_stdin_contents()
	print " "
	print " "
	print "============================================================================="
	print "Begin to execute: ==========================================================="
	print "============================================================================="
	print " "
	
###################################################
def print_usage():
	print "Usage: python " + str(sys.argv[0]) + " option machine_program_file [name_of_stdin_file]"
	print "    'option' must be one of the following:"
	print "        '-full'   for ordinary simulation"
	print "        '-step'   for single stepping through program"
	print "        '-quiet'  for showing only the final status of the computer"
	print "        '-silent' for showing no output on the console"
	print "        '-short'  for showing only memory locations from 0x00 to 0x1F"
	print "        '-20'     for showing memory locations from 0x00 to 0x1F"
	print "        '-40'     for showing memory locations from 0x00 to 0x3F"
	print "        '-60'     for showing memory locations from 0x00 to 0x5F"

	sys.exit()

###################################################
# message about which instruction has just been executed
# and the state of the machine thereafter
def print_message():
	if opc==0:
		print "HLT"
	if opc==1:
		print "ADD" + " R" + str(format(d, '1X')) + " R" + str(format(s, '1X')) + " R" + str(format(t, '1X')) 
	elif opc==2:
		print "SUB" + " R" + str(format(d, '1X')) + " R" + str(format(s, '1X')) + " R" + str(format(t, '1X')) 
	elif opc==3:
		print "AND" + " R" + str(format(d, '1X')) + " R" + str(format(s, '1X')) + " R" + str(format(t, '1X')) 
	elif opc==4:
		print "XOR" + " R" + str(format(d, '1X')) + " R" + str(format(s, '1X')) + " R" + str(format(t, '1X')) 
	elif opc==5:
		print "SHL" + " R" + str(format(d, '1X')) + " R" + str(format(s, '1X')) + " R" + str(format(t, '1X')) 
	elif opc==6:   
		print "SHR" + " R" + str(format(d, '1X')) + " R" + str(format(s, '1X')) + " R" + str(format(t, '1X')) 
	elif opc==7:   
		print "LDA" + " R" + str(format(d, '1X')) + " 0x" + str(format(imm, '02x'))
	elif opc==8:   
		print "LD" + " R" + str(format(d, '1X')) + " 0x" + str(format(imm, '02x'))
	elif opc==9:   
		print "ST" + " R" + str(format(d, '1X')) + " 0x" + str(format(imm, '02x'))
	elif opc==0xA:
		print "LDI" + " R" + str(format(d, '1X')) +   "R" + str(format(t, '1X')) 
	elif opc==0xB:
		print "STI" + " R" + str(format(d, '1X')) +   "R" + str(format(t, '1X')) 		
	elif opc==0xC:   
		print "BZ" + " R" + str(format(d, '1X')) + " 0x" + str(format(imm, '02x'))
	elif opc==0xD:   
		print "BP" + " R" + str(format(d, '1X')) + " 0x" + str(format(imm, '02x'))
	elif opc==0xE:
		print "JR" + " R" + str(format(d, '1X'))  	
	elif opc==0xF:
		print "JL" + " R" + str(format(d, '1X')) + " 0x" + str(format(imm, '02x'))

	print "State after instruction: ",
	print "PC: " + str(format(PC, '04x'));
	print "============================================================================="
	print_register_contents()
	print "============================================================================="
	print_memory_contents(mem_range);
	print "============================================================================="
	


###################################################
# print final messages after simulation and
# print to file "stdout"
#
def final_print_and_write_to_stdout():
	if quiet_mode == 1:
		# Print state: ***************************************
		print "State after program has finished executing: "
		print "============================================================================="
		print_register_contents()
		print "============================================================================="
		print_memory_contents(mem_range);
		print "============================================================================="
	
	if silent_mode == 0:
		print " "
		print_stdout_contents()
		
	write_stdout_contents_to_file()
	
	if quiet_mode == 1:
		print " "
		print "Executed " + str(instruction_counter) + " instructions."
		print " "
		print "*****************************************************************************"
		print "*GOOD BYE *******************************************************************"
		print "*****************************************************************************"
		print " "
		print " "


######################################################################################################
######################################################################################################
# Main starts here
######################################################################################################
######################################################################################################
check_mode_and_files()

# print banner
if silent_mode == 0:
	initial_printout(mem_range)

# initialize program counter:	
PC = 0x10

##################################################
# "fetch-execute" loop:
##################################################
while True:
	instruction_counter = instruction_counter + 1
	
	# Fetch **********************************************
	IR = mem[PC]
	
	# R0 is constant 0. Whenever someone wrote a value into it, we reset it here.
	R[0] = 0; 

	if do_print:
		print "============================================================================="
		print "Executing Instruction: " + str(hex(PC)) + ": " + str(format(IR, '04x')) + "   -->  ",

	# compute aliases of IR ******************************
	opc = int((format(IR, '04x'))[0:1], 16)
	d   = int((format(IR, '04x'))[1:2], 16)
	s   = int((format(IR, '04x'))[2:3], 16)
	t   = int((format(IR, '04x'))[3:4], 16)
	imm = int((format(IR, '04x'))[2:4], 16)

	# Increment PC ***************************************
	PC = PC + 1
		
	# Decode & Execute************************************

	if opc == 0:   	# HLT
		break		# end of execution; break from endless loop

	elif opc == 1:	# ADD
		R[d] = (R[s] + R[t]) % 0x10000;
	elif opc == 2:	# SUB
		R[d] = (R[s] - R[t]) % 0x10000;
	elif opc == 3: 	# AND
		R[d] = (R[s] & R[t]) % 0x10000;
	elif opc == 4:	# XOR
		R[d] = (R[s] ^ R[t]) % 0x10000;
	elif opc == 5:	# SHL
		# max shift is defined by 4 lower bits in Rt
		shift_amount = R[t] & 0xF;
		R[d] = (R[s] << shift_amount) % 0x10000;
	elif opc == 6:	# SHR
		# max shift is defined by 4 lower bits in Rt
		shift_amount = R[t] & 0xF;
		#extract bit 15 of Rs
		bit15 = (R[s] & 0x8000) >> 15;  
		# first get a copy of Rs into Rd:
		R[d] = R[s]
		#now keep the most significant bit as it was:
		for x in range(shift_amount):
			R[d] = R[d] >> 1;
			if bit15 == 1:
				R[d] = R[d] | 0x8000;
	elif opc == 7:	# LDA
		R[d] = imm
	elif opc == 8:	# LD
		if imm == 0xFF:
			if stdin_index < len(stdin):
				mem[0xFF] = stdin[stdin_index]
				stdin_index = stdin_index + 1
			else:
				print " "
				print "----------------------------------------------------------"
				print "No (further) value in STDIN found -- Quitting with program"
				print "----------------------------------------------------------"
				break
		R[d] = mem[imm]
	elif opc == 9:	# ST
		if imm != 0xFE:   #don't set "input control register" (mapped to 0xFE) to 0.
			mem[imm] = R[d]
		if imm == 0xFF:
			stdout.append(mem[imm])
	elif opc == 0xA: # LDI
		offset = s
		if R[t] + offset > 0xFF:
			print "Instruction fetched from: " + str(hex(PC-1))
			print "Error with LDI: R" + str(t) + " offset: " + str(R[t] + offset)
			break
		if R[t] + offset == 0xFF:
			if (stdin_index < len(stdin)):
				mem[0xFF] = stdin[stdin_index]
				stdin_index = stdin_index + 1
			else:
				print " "
				print "----------------------------------------------------------"
				print "No (further) value in STDIN found -- Quitting with program"
				print "----------------------------------------------------------"
				break
		R[d] = mem[R[t] + offset]
	elif opc == 0xB:	# STI
		offset = s
		if R[t] + offset > 0xFF:
			print "Instruction fetched from: " + str(hex(PC-1))
			print "Error with STI: R" + str(t) + " offset: " + str(R[t] + offset)
			break
		if (R[t] + offset != 0xFE):   #don't set "input control register" (mapped to 0xFE) to 0.
			mem[R[t] + offset] = R[d]
		if (R[t] + offset == 0xFF):
			stdout.append(mem[R[t] + offset])
	elif opc == 0xC:	# BZ
		if R[d] == 0:
			PC = imm;
	elif opc == 0xD:	# BP
		if ((R[d] > 0) & (R[d] < 0x8000)):
			PC = imm;				
	elif opc == 0xE:	# JR
		PC = R[d]
	else: #opc == 0xF:	# JL
		R[d] = PC
		PC = imm

	# print machine state after executing an instruction: 
	if do_print:
		print_message()
	
	#  wait for user input
	if single_step:
		raw_input("Hit RETURN in order to continue")
		
##################################################
# end of fetch-execute loop
##################################################

# print final message for instruction HLT:
if do_print:
	print_message()
	
final_print_and_write_to_stdout()

# end main
##################################################





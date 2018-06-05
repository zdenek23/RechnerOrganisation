#!/usr/bin/env

#########################################################
# KC Posch
# September 2015
#
# Assembler for TOY, S-TOY, L-TOY, and XL-TOY
#
# For use within teaching in "Rechnerorganisation"
# For experimental use only.
#
#########################################################
#
# Use: 
#   python stoyasm.py -option filename_with_assembly_code
#
# option must be one of the following: 
#	-t   for assembling code for ordinary TOY
#	-s   for assembling code for S-TOY
#	-l   for assembling code for L-TOY 
#   -xl  for assembling code for XL-TOY
#
#   -a   for assembling code for A-TOY (advanced)
#
#########################################################
#
# Logging: 
#   The assembler logs all actions to file "debug.log"
#
#########################################################
#
# Comment character: 
#    everything after a semicolon (";") in a line of
#    the input file is considered to be a comment
#    and is neglected by the assembler
#
#########################################################
#
# Assembler directives:
#
#   ORG	... define the "origin", i.e. the start address
#           of the following instruction
#
#   eample: 
#		ORG 0x10    ; put the following instruction at
#					; address 0x10 
#
#
#	DW	... define the contents of one or several words
#           in main memory
#			
#   examples:
#
#		A DW 5		; symbolic address A with value 5
#
#		B DW 0xC    ; symbolic address B with hex-value C
#
#		D DW 7 8 9  ; define the contents of 3 memory
#					; locations starting with symbolic
#					; address D
#   
#
#	DUP ... reserve memory locations
#
#	example:
#
#		D DUP 5		; reserve 5 memory locations beginning
#                   ; at symbolic address D
#                   ; the values are not defined
#
#
###########################################################
#
# TOY instruction set:
# 
# Instruction formats of the original TOY:
#
#             | .... | .... | .... | .... |
#  Format 1:  |  op  |  d   |  s   |  t   |
#  Format 2:  |  op  |  d   |     imm     |
#
#
# ARITHMETIC and LOGICAL operations
#    1: ADD Rd Rs Rt            ;R[d] <- R[s] + R[t]
#    2: SUB Rd Rs Rt            ;R[d] <- R[s] - R[t]
#    3: AND Rd Rs Rt            ;R[d] <- R[s] & R[t]
#    4: XOR Rd Rs Rt            ;R[d] <- R[s] ^ R[t]
#    5: SHL Rd Rs Rt            ;R[d] <- R[s] << R[t]
#    6: SHR Rd Rs Rt            ;R[d] <- R[s] >> R[t]
#
# TRANSFER between registers and memory
#    7: LDA Rd imm		;load immediate R[d] <- imm
#    8: LD	Rd imm		;load           R[d] <- mem[imm]
#    9: ST  Rd imm      ;store          mem[imm] <- R[d]
#    A: LDI Rd Rt       ;load indirect  R[d] <- mem[R[t]]
#    B: STI Rd Rt       ;store indirect mem[R[t]] <- R[d]
#
# CONTROL
#    0: HLT             ;halt           halt
#    C: BZ Rd imm       ;branch zero    if (R[d] == 0) pc <- imm
#    D: BP Rd imm       ;branch pos.    if (R[d] > 0) pc <- imm
#    E: JR Rd           ;jump register  pc <- R[d]
#    F: JL Rd imm       ;jump and link  R[d] <- pc; pc <- imm
#
#
#############################################################
#
# Additions for L-TOY:
#
# Register RF is used as a stack pointer.
#
# PUSH Rt               ;(1) R[F] <- R[F] - 1
#                       ;(2) mem[R[F]] <- R[t] 
#
# POP Rt                ;(1) R[t] <- mem[R[F]] 
#	                    ;(2) R[F] <- R[F] + 1
#
# CALL imm              ;(1) R[F] <- R[F] - 1
#                       ;(2) mem[R[F]] <- PC 
#                       ;    PC <- imm
#
# RET                   ;(1) PC <- mem[R[F]] 
#	                    ;(2) R[F] <- R[F] + 1
#
# ION                   ; IEN <- 1 
#
# IOF                   ; IEN <- 0 
#
# RETI                  ;(1) PC <- mem[R[F]] 
#	                    ;(2) R[F] <- R[F] + 1
#                       ; IEN <- 1
#
#############################################################
#
# Additions for XL-TOY:
#
# CALLI Rt              ;(1) R[F] <- R[F] - 1
#                       ;(2) mem[R[F]] <- PC 
#                       ;    PC <- mem[R[t]]
#
#############################################################
#
# In addition to L-TOY, available in S-TOY:
#
# LDI Rd s Rt           ;indirect load with offset:
#                       ;R[d] <- mem[R[t] + s] 
#
# STI Rd s RT           ;indirect store with offset:
#                       ;mem[R[t] + s] <- R[d]
# 
# changed JL: if register == R0, then it is "CALL label":
# CALL imm == JL R0 imm
# JL R0 imm             ;(1) R[F] <- R[F] - 1
#                       ;(2) mem[R[F]] <- PC 
#                       ;    PC <- imm
#  
# changed JR: if register == R0, then it is "RET":
# JR R0                 ;(1) PC <- mem[R[F]] 
#	                    ;(2) R[F] <- R[F] + 1
#
#########################################################
#
# Additions for A-TOY:
#
# LDX Rd Rs Rt          ;indirect load with index
#                       ;R[d] <- mem[R[s] + R[t]]
#                     
# STX Rd Rs Rt          ;indirect store with index
#                       ;mem[R[s] + R[t]] <- R[d]
#
# PUSHA 				; push all R1..RE (0B00)
# POPA					; pop all RE..R1  (0C00)
#
# XCHG Rs Rt			; Rs <-> mem[Rt]
#
# SWI Rt				; IOF, CALLI Rt (software interrupt)
#
#########################################################

import sys
import logging
import re
import os

LOGGING=0

# logging to file "debug.log":
if LOGGING == 1:
    logging.basicConfig(filename='debug.log', filemode='w', level=logging.DEBUG)

#########################################################
# subroutine for reporting an error with subsequent exit:
#########################################################
def error_and_exit(msg, lineno, line):
	print "ERROR: " + msg + " in line ",
	print lineno,
	print ": ",
	print line
	exit(1)

#########################################################
# all opcodes:
#########################################################
opcodes = {'HLT':0, 'ADD':1, 'SUB':2, 'AND':3, 'XOR':4, 'SHL':5, 'SHR':6, 'LDA':7,
            'LD':8, 'ST':9,  'LDI':10, 'STI':11, 'BZ': 12, 'BP':13, 'JR':14, 'JL':15,
            'PUSH':16, 'POP':17, 'CALL':18, 'RET':19, 'ION':20, 'IOF':21, 'RETI':22, 'CALLI':23,
            'LDX':14, 'STX':15, 
            'PUSHA':24, 'POPA':25, 'XCH':26, 'SWI':27, 
            'BZI':28} 

#########################################################
# amount of parameters after mnemonic:
#########################################################
arg_count = {'HLT':0, 'ADD':3, 'SUB':3, 'AND':3, 'XOR':3, 'SHL':3, 'SHR':3, 'LDA':2,
            'LD':2, 'ST':2, 'LDI':3, 'STI':3, 'BZ':2, 'BP':2, 'JR':1, 'JL':2,
            'PUSH':1, 'POP':1, 'CALL':1, 'RET':0, 'ION':0, 'IOF':0, 'RETI':0, 'CALLI':1,
            'LDX':3, 'STX':3, 'PUSHA':0, 'POPA':0, 'XCH':2, 'SWI':1, 'BZI':2}  
            
#########################################################
# types of instruction:
#
# opc mnem type comment
#  0 HLT	0	no params
#  1 ADD	1 	3 params, 3 register names
#  2 SUB	1	3 params, 3 register names
#  3 AND	1	3 params, 3 register names
#  4 XOR	1	3 params, 3 register names
#  5 SHL	1	3 params, 3 register names
#  6 SHR	1	3 params, 3 register names
#  7 LDA	2	2 params: register name + label or number
#  8 LD		2	2 params: register name + label or number
#  9 ST		2	2 params: register name + label or number

#  A LDI	3   2 params: register name + register name
#  B STI	3   2 params: register name + register name

# addition for S-TOY: changed LDI and STI:
#  A LDI	3   2 params: register name (+ offset) + register name
#  B STI	3   2 params: register name (+ offset) + register name

#  C BZ		2   2 params: register name + label or number
#  D BP		2	2 params: register name + label or number

#  E JL		2   2 params: register name + label or number
#  
#  F JR		4   1 param:  register name
#
# additional instructions for S-TOY, L-TOY:
#
#   PUSH	5   1 param: register name		010r
#	POP		5   1 param: register name		020r
#	CALL	6   1 param: label or number	L-TOY: 03ll                                            
#	RET		0   0 param						        L-TOY: 0400
#                                           
#   ION		0   0 param						0500
#   IOF		0   0 param						0600
#   RETI	0   0 param						0700
#
# additional instruction for XL-TOY:
#
#   CALLI	5   1 param: register name		080r
#   BZI     8   2 params: 2 register names  0dst
#
# additional instructions for A-TOY:
#   
#  E LDX	1   3 params, 3 register names
#  F STX	1   3 params, 3 register name
#
#  PUSHA	0	0 params
#  POPA		0	0 params
#
#  XCHG     7   2 params,  2 register names, Rs <-> mem[Rt]
#   
#  SWI  6  1 param: label or number       #old version in 2016, apparently wrong: SWI      5	1 param: register name 	
#
   
#########################################################
instr_type   = {'HLT':0, 'ADD':1, 'SUB':1, 'AND':1, 'XOR':1, 'SHL':1, 'SHR':1, 'LDA':2,
            'LD':2, 'ST':2, 'LDI':3, 'STI':3, 'BZ':2, 'BP':2, 'JR':4, 'JL':2,
            'PUSH':5, 'POP':5, 'CALL':6, 'RET':0, 'ION':0, 'IOF':0, 'RETI':0, 'CALLI':5,
            'LDX':1, 'STX':1, 'PUSHA':0, 'POPA':0, 'XCH':7, 'SWI':6, 'BZI':7}  

#########################################################
# all register names
#########################################################
registers = {'R0':0, 'R1':1, 'R2':2,  'R3':3,  'R4':4,  'R5':5,  'R6':6,  'R7':7,
             'R8':8, 'R9':9, 'RA':10, 'RB':11, 'RC':12, 'RD':13, 'RE':14, 'RF':15}


#########################################################
# symbol table, list with code, etc.
#########################################################
symboltable = {}   # gets filled with all symbols together with address
code = []		   

lineno = 0		   # line number in assembly-language file
codelineno = 0     # address

lineno_of_first_instruction = -1 
had_first_instruction = 0   # false (=0) or true (= 1)

found_org = 0

def print_usage():
	print "Usage: python " + str(sys.argv[0]) + " -[tslx] [-p] filename" 
	print "\t-t   for assembling code for ordinary TOY"
	print "\t-s   for assembling code for S-TOY"
	print "\t-l   for assembling code for X-TOY"
	print "\t-xl  for assembling code for XL-TOY"
	print "\t-a   for assembling code for A-TOY"

	print "\t-p   for printing machine code together with assembly code"  	



#########################################################
# MAIN starts here:
#########################################################

#########################################################
# check command line, check options, read file:
#########################################################
if len(sys.argv) < 2:
	print_usage()
	sys.exit()
	
elif len(sys.argv) == 2:
	option = "t"

elif len(sys.argv) == 3 and (sys.argv[1])[0:1] != '-':
	print_usage()
	sys.exit()

elif len(sys.argv) == 4 and (sys.argv[1])[0:1] != '-' and (sys.argv[2])[0:1] != '-':
	print_usage()
	sys.exit()

elif len(sys.argv) > 4:
	print_usage()
	sys.exit()

if len(sys.argv) > 2:
	if str(sys.argv[1]) == "-t":
		option = "t"
	elif str(sys.argv[1]) == "-s":
		option = "s"
	elif str(sys.argv[1]) == "-l":
		option = "l"
	elif str(sys.argv[1]) == "-xl":
		option = "xl"
	elif str(sys.argv[1]) == "-a":
		option = "a"
	else:
		print_usage()
		sys.exit()

prettyprint = 0

if len(sys.argv) == 4:
	if sys.argv[2] == "-p":
		prettyprint = 1
	else:
		print_usage()
		sys.exit()

	
if os.path.isfile(str(sys.argv[len(sys.argv)-1])):
	f = open( str(sys.argv[len(sys.argv)-1]), "r" )
	lines = f.readlines()
	f.close()
else:
	print "File not found: " + str(sys.argv[len(sys.argv)-1])
	sys.exit()


#########################################################
# first pass:
#
# generate entries in symboltable and
# produce entries in code
#
# code is a list of lists
#
# if the assembler directives before the first instruction
# use more than 16 memory words then report error and exit.
#########################################################
for line in lines:
	lineno = lineno + 1
	l = line.split(";", 1)		# split in order to remove comments
	
	if l[0].strip() != '':		# if not a line with comments only
		l[0] = l[0].replace(",", " ")   
		tokenlist = l[0].split()

		if str(tokenlist[0]) not in opcodes and str(tokenlist[0]) != "ORG":
			if not re.search("[a-zA-Z_]", str(tokenlist[0])[0]):	# check whether label starts with a non-digit
				error_and_exit("Symbol must start with a letter", lineno, line)  
			if str(tokenlist[0]) not in symboltable:  # generate entries in symboltable:
				symboltable[tokenlist[0]] = codelineno
			else:
				error_and_exit("Symbol already defined previously: Error", lineno, line)
		if str(tokenlist[0]) in opcodes:	# line starts with opcode
			if str(tokenlist[0]) == 'LDI' or str(tokenlist[0]) == 'STI': 
				if len(tokenlist)-1 != 2 and len(tokenlist)-1 != 3:
					error_and_exit("Wrong number of arguments", lineno, line)
				if len(tokenlist)-1 == 2:
					tokenlist.insert(2, '0') # inserting the missing '0' between the register names
			elif (len(tokenlist)-1) != arg_count[tokenlist[0]]:
					error_and_exit("Wrong number of arguments", lineno, line)

			tokenlist.insert(0, '')
			tokenlist.insert(0, codelineno)
			tokenlist.insert(0, lineno)
			
			tokenlist.append(line)
			
			code.append(tokenlist)
			if had_first_instruction == 0:
				lineno_of_first_instruction = codelineno 
				had_first_instruction = 1
			codelineno = codelineno + 1
		
		elif len(tokenlist) > 1 and str(tokenlist[1]) in opcodes:     		# line starts with label:
			if str(tokenlist[1]) == 'LDI' or str(tokenlist[1]) == 'STI': 
				if len(tokenlist)-1 != 3 and len(tokenlist)-1 != 4:
					error_and_exit("Wrong number of arguments", lineno, line)
				if len(tokenlist)-1 == 3:
					tokenlist.insert(3, '0') # inserting the missing '0' between the register names
			elif (len(tokenlist)-2) != arg_count[tokenlist[1]]:
				error_and_exit("Wrong number of arguments", lineno, line)
			
			tokenlist.insert(0, codelineno)
			tokenlist.insert(0, lineno)
			
			tokenlist.append(line)
			
			code.append(tokenlist)
			if had_first_instruction == 0:
				lineno_of_first_instruction = codelineno 
				had_first_instruction = 1
			codelineno = codelineno + 1
		
		elif len(tokenlist) > 1 and tokenlist[1] == "DW":
			if (len(tokenlist)) < 3:
				error_and_exit("Wrong number of arguments", lineno, line)
			
			amount = len(tokenlist) - 2
			tokenlist.insert(0, codelineno)
			tokenlist.insert(0, lineno)
			tokenlist.append(line)
			
			code.append(tokenlist) 
			codelineno = codelineno + 1
			
			tl = tokenlist[:]   # deep copy
			for x in range(1, amount):
				tl[1] = codelineno
				tl[2] = ''
				tl[3] = 'DWC'	# DW continued
				tl[4] = tl[4+x]
				code.append(tl[0:5])
				codelineno = codelineno + 1

		elif len(tokenlist) > 1 and tokenlist[1] == "DUP":
			if (len(tokenlist)) != 3:
				error_and_exit("Wrong number of arguments", lineno, line)
			
			tokenlist.insert(0, codelineno)
			tokenlist.insert(0, lineno)
			
			tokenlist.append(line)
			
			code.append(tokenlist)
			codelineno = codelineno + int(tokenlist[4], 0)
		
		elif len(tokenlist) == 2 and tokenlist[0] == "ORG":
			found_org = 1
			tokenlist.insert(0, codelineno)
			tokenlist.insert(0, lineno)
			tokenlist.append(line)
			code.append(tokenlist)
		else:
			error_and_exit("Unknown instruction", lineno, line)
					
if LOGGING == 1:
    logging.debug("symboltable after first round is: ")		
    logging.debug(symboltable)
    logging.debug("")
    logging.debug("code after first round is: ")
    logging.debug(code)
    logging.debug("")
    logging.debug("lineno of first instruction is " + str(lineno_of_first_instruction))

if lineno_of_first_instruction > 16:
	print "ERROR: More than 16 words before first instruction."
	exit(1)


#########################################################
# second pass: modify code such that first instruction
# is put on address 0x10; or if "ORG" is found, then
# change addresses according to specification of ORG.
#
# in case that memory consumption exceeds size of memory,
# report error and exit
#########################################################

change_codelineno_from_here = 0
last_address = -1
last_codelineno = -1
codelineno_offset = 0

	
if found_org == 0:
	codelineno_offset = 16 - lineno_of_first_instruction
	for line in code:
		if line[1] == lineno_of_first_instruction:
			change_codelineno_from_here = 1
	
		if change_codelineno_from_here == 1:
			line[1] = line[1] + codelineno_offset
			if line[2] in symboltable:
				symboltable[line[2]] = line[1]

		last_codelineno = line[1]
	
		if line[2] in opcodes:
			last_address = last_codelineno
		elif line[3] == "DUP":
			last_address = last_codelineno + int(line[4], 0)-1
		elif line[3] == "DW":
			last_address = last_codelineno + 1
else:
	for line in code:
		if line[2] == "ORG":
			if not (re.search(r"^[0-9][0-9]*", str(line[3])) or re.search(r"0x[0-9]*", str(line[3]))):  #is it not int or hex?
				error_and_exit("Use of undefined address", line[0], ' '.join(map(str,line[2:4])))
			elif option != 'xl' and int(line[3],0) > 255:
				error_and_exit("Address is too large", line[0], ' '.join(map(str,line[2:4])))
			elif option == 'xl' and int(line[3],0) > 65536:
				error_and_exit("Address is too large", line[0], ' '.join(map(str,line[2:4])))
			else:
				codelineno_after_org = int(line[3], 0)
				if codelineno_after_org <= last_codelineno:
					error_and_exit("ORG specifies to overwrite previous code:", line[0], ' '.join(map(str,line[2:4])))
				
				codelineno_offset = codelineno_after_org - line[1]
		else:			
			line[1] = line[1] + codelineno_offset
			if line[2] in symboltable:
				symboltable[line[2]] = line[1] 
			last_codelineno = line[1]
	
			if line[2] in opcodes:
				last_address = last_codelineno
			elif line[3] == "DUP":
				last_address = last_codelineno + int(line[4], 0)-1
			elif line[3] == "DW":
				last_address = last_codelineno + 1
			
if LOGGING == 1:
    logging.debug("codelineno offset is " + str(codelineno_offset))
    logging.debug("code after second round is: ")
    logging.debug(code)
    logging.debug("")
    logging.debug(symboltable)
    logging.debug("")
    #logging.debug("last codelineno is " + str(last_codelineno))
    logging.debug("")
    logging.debug("last_address is " + str(last_address))

if option != 'xl' and last_address > 0xFE:
	print "ERROR: Code and data exceed maximum size of memory (256 words)"
	exit(1)
elif last_address > 0xFFFF:
	print "ERROR: Code and data exceed maximum size of memory (256 words)"
	exit(1)



#########################################################
# third pass: modify code
#
# exchange symbols with real address
# exchange register names with numbers
# exchange signed offset with 2's complement representation in hex
#########################################################
for line in code:
	if line[0] != "ORG":
		if line[3] in opcodes:
			if instr_type[line[3]] == 1:	# work on ADD, SUB, AND, XOR, SHL, SHR, LDX, STX	
				for index in [4, 5, 6]:
					if line[index] in registers:
						line[index] = registers[line[index]]
					else:
						error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))
	
			elif instr_type[line[3]] == 2:	# work on LDA, LD, ST, BZ, BP, JL
				if line[5] in symboltable:
					line[5] = symboltable[line[5]]

				if not (re.search(r"^[0-9][0-9]*", str(line[5])) or re.search(r"0x[0-9]*", str(line[5]))):  #is it not int or hex?
					error_and_exit("Use of undefined symbol or address", line[0], ' '.join(map(str,line[2:6])))
				
				if re.search(r"0x[0-9]*", str(line[5])):   # if hex, then convert to decimal
					line[5] = int(line[5],0)

				if option != 'xl':
					if int(str(line[5]),0) > 255:
						error_and_exit("Address is too large", line[0], ' '.join(map(str,line[2:6])))
				else: # option == 'xl'
					if int(str(line[5]),0) >= 65536:
						error_and_exit("Address is too large", line[0], ' '.join(map(str,line[2:6])))
				
				if line[3] == 'LDA' and int(str(line[5]),0) > 255:
					error_and_exit("Constant for LDA is too large", line[0], ' '.join(map(str,line[2:6])))
                
				if line[4] in registers:
					line[4] = registers[line[4]]
				else:
					error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))
			
			elif instr_type[line[3]] == 3:	# work on LDI, STI
				line[5] = int(line[5])
				
				if (option != 's' and option != 'a' and option != 'xl') and line[5] != 0:
					error_and_exit("Did you forget '-s' or '-a'? Offset must be 0 in plain TOY", line[0], line[7])
	
				if line[5] < 0 or line[5] > 15:
					error_and_exit("Offset out of range [0...+15]", line[0], ' '.join(map(str,line[2:6])))
	
				if line[4] in registers:
					line[4] = registers[line[4]]
				else:
					error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))
					
				if line[6] in registers:
					line[6] = registers[line[6]]
				else:
					error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))
	
	
			elif instr_type[line[3]] == 4:	# work on JR
				if line[4] in registers:
					line[4] = registers[line[4]]
				else:
					error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))
	
			elif instr_type[line[3]] == 5:	# work on PUSH, POP, CALLI
				if line[4] in registers:
					line[4] = registers[line[4]]
				else:
					error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))
	
			elif instr_type[line[3]] == 6:	# work on CALL and SWI
				if line[4] in symboltable:
					line[4] = symboltable[line[4]]

				elif not (re.search(r"^[0-9][0-9]*", str(line[4])) or re.search(r"0x[0-9]*", str(line[4]))):  #is it not int or hex?
					error_and_exit("Use of undefined symbol or address", line[0], ' '.join(map(str,line[2:6])))
				elif int(line[4],0) > 255:
					error_and_exit("Address is too large", line[0], ' '.join(map(str,line[2:6])))
				
			elif instr_type[line[3]] == 7:	# work on XCH, BZI
				if line[4] in registers and line[5] in registers:
					line[4] = registers[line[4]]
					line[5] = registers[line[5]]
				else:
					error_and_exit("Unknown name of register", line[0], ' '.join(map(str,line[2:6])))

					
if LOGGING == 1:
    logging.debug("code after third round is: ")
    logging.debug(code)


#########################################################
# fourth pass: 
# generate machinecode and insert in each code line
#########################################################

machinecode = ""
no = -1

for line in code:
	no = no + 1
	if line[3] in opcodes:
		if instr_type[line[3]] == 1:  # ADD, SUB, AND, XOR, SHL, SHR, LDX, STX
			#machinecode = str(opcodes[line[3]]) 
			machinecode = hex(opcodes[line[3]])[2:] 
			machinecode = machinecode + str(hex(line[4]))[2:3] 
			machinecode = machinecode + str(hex(line[5]))[2:3]  
			machinecode = machinecode + str(hex(line[6]))[2:3]
			machinecode = machinecode.upper() 
			line.insert(0, machinecode)

		elif instr_type[line[3]] == 2: # LDA, LD, ST, BZ, BP
		    if option != 'xl':
		        machinecode = hex(opcodes[line[3]])[2:]             # first digit
		        machinecode = machinecode + hex(line[4])[2:3]       # second digit
		        machinecode = machinecode + hex(int(str(line[5]), 0))[2:].zfill(2) # third and fourth digit
		        machinecode = machinecode.upper() 
		        line.insert(0, machinecode)
		    else: # option == 'xl'
				if str(line[3]) == 'LDA':
					machinecode = hex(opcodes[line[3]])[2:]             # first digit
					machinecode = machinecode + hex(line[4])[2:3]       # second digit
					machinecode = machinecode + hex(int(str(line[5]), 0))[2:].zfill(2) # third and fourth digit
					machinecode = machinecode.upper() 
					line.insert(0, machinecode)	
				else: # str(line[3]) != 'LDA': # is LD, ST, BZ, BP
					# compare line[5] with line[1]: are they in the same page?
					# if not: is line[5] in page 0?
                    # handling same page addressing:
					if int(line[5]) / 128 == line[1] / 128:
						machinecode = hex(opcodes[line[3]])[2:]             # first digit
						machinecode = machinecode + hex(line[4])[2:3]       # second digit
						machinecode = machinecode + hex(int(str(line[5]), 0) % 128)[2:].zfill(2) # third and fourth digit
						machinecode = machinecode.upper() 
						line.insert(0, machinecode)
					# handling addressing with page 0:
					elif (line[5] < 0x80): # page 0 addressing
						machinecode = hex(opcodes[line[3]])[2:]             # first digit
						machinecode = machinecode + hex(line[4])[2:3]       # second digit
						#machinecode = machinecode + hex(int(str(line[5]), 0))[2:].zfill(2) # third and fourth digit
						# set bit 7 of code to 1:
						machinecode = machinecode + hex( 128 + int(str(line[5]), 0) % 128  )[2:].zfill(2)
						machinecode = machinecode.upper() 
						line.insert(0, machinecode)
					else:
						error_and_exit("Symbolic address is neither on page 0 nor on current page ", str(line[0]), str(line[5]))			        	
		        	
		elif instr_type[line[3]] == 3: # LDI, STI
			machinecode = hex(opcodes[line[3]])[2:] 
			machinecode = machinecode + str(hex(line[4]))[2:3] 
			machinecode = machinecode + str(hex(line[5]))[2:3] 
			machinecode = machinecode + str(hex(line[6]))[2:3] 
			machinecode = machinecode.upper() 
			line.insert(0, machinecode)
		
		elif instr_type[line[3]] == 4: # JR
			machinecode = hex(opcodes[line[3]])[2:] 
			machinecode = machinecode + str(hex(line[4]))[2:3]
			machinecode = machinecode + "00" 
			machinecode = machinecode.upper() 
			line.insert(0, machinecode)

		elif instr_type[line[3]] == 6 and line[3] == 'CALL': # CALL 
			if option == 't':
				error_and_exit("Instruction CALL does not exist in plain TOY ", str(line[0]), str(line[5]))
			elif option == 's':
				machinecode = "03"; #new in 2017. Old version had: "F0"   # "CALL addr" is the same as "JL R0 addr" 
				machinecode = machinecode + hex(int(str(line[4]), 0))[2:].zfill(2)
				machinecode = machinecode.upper() 
				line.insert(0, machinecode)
			elif option == 'a':
				machinecode = "03"
				machinecode = machinecode + hex(int(str(line[4]), 0))[2:].zfill(2)
				machinecode = machinecode.upper() 
				line.insert(0, machinecode)			
			elif option == 'xl':
				if (line[4] < 0x80): # page 0 addressing
					machinecode = "03"                     # first 2 digits
					#machinecode = machinecode + hex(int(str(line[5]), 0))[2:].zfill(2) # third and fourth digit
					# set bit 7 of code to 1:
					machinecode = machinecode + hex( 128 + int(str(line[4]), 0) % 128  )[2:].zfill(2)
					machinecode = machinecode.upper() 
					line.insert(0, machinecode)
				elif line[4] / 128 == line[1] / 128:   # handling same page addressing
					machinecode = "03"                     # first 2 digits
					machinecode = machinecode + hex(int(str(line[4]), 0) % 128)[2:].zfill(2) # third and fourth digit
					machinecode = machinecode.upper() 
					line.insert(0, machinecode)
				else:
					error_and_exit("Symbolic address is neither on page 0 nor on current page ", str(line[0]), str(line[5]))  
			

		elif instr_type[line[3]] == 6 and line[3] == 'SWI': # SWI 
			if option == 't' or option == 's':
				error_and_exit("Instruction SWI does not exist in plain TOY ", str(line[0]), str(line[5]))
			elif option == 'a' or option == 'xl':
				machinecode = "0A";      
				machinecode = machinecode + hex(int(str(line[4]), 0))[2:].zfill(2)
				machinecode = machinecode.upper() 
				line.insert(0, machinecode)			
	
		elif line[3] == 'HLT':  		#instr_type[line[3]] == 0
			line.insert(0, "0000")

		elif line[3] == 'RET':
			if option == 't':
				error_and_exit("Instruction RET does not exist in plain TOY ", str(line[0]), str(line[5]))
			elif option == 's':	   # "RET" is the same as "JR R0"
				line.insert(0, "0400");    #new for 2017. Old version had: line.insert(0, "E000")
			elif option == 'a' or option == 'xl':
				line.insert(0, "0400")

		elif line[3] == 'ION':
			if option == 't':
				error_and_exit("Instruction ION does not exist in plain TOY ", str(line[0]), str(line[3]))
			else:
				line.insert(0, "0600")	

		elif line[3] == 'IOF':
			if option == 't':
				error_and_exit("Instruction ION does not exist in plain TOY ", str(line[0]), str(line[3]))
			else:
				line.insert(0, "0500")	

		elif line[3] == 'RETI':
			if option == 't':
				error_and_exit("Instruction RETI does not exist in plain TOY ", str(line[0]), str(line[3]))
			elif option == 's':
				error_and_exit("Instruction RETI does not exist in S-TOY ", str(line[0]), str(line[3]))
			else:
				line.insert(0, "0700")

		elif line[3] == 'PUSH':
			if option == 't':
				error_and_exit("Instruction PUSH does not exist in plain TOY ", str(line[0]), str(line[3]))
			else:
				machinecode = "010" + str(hex(line[4]))[2:3]
			line.insert(0, machinecode)
			
		elif line[3] == 'PUSHA':
			if option == 't':
				error_and_exit("Instruction PUSHA does not exist in plain TOY ", str(line[0]), str(line[3]))
			line.insert(0, "0B00")

		elif line[3] == 'POP':
			if option == 't':
				error_and_exit("Instruction POP does not exist in plain TOY ", str(line[0]), str(line[3]))
			machinecode = "020" + str(hex(line[4]))[2:3]
			line.insert(0, machinecode)

		elif line[3] == 'POPA':
			if option == 't':
				error_and_exit("Instruction POPA does not exist in plain TOY ", str(line[0]), str(line[3]))
			line.insert(0, "0C00")

		elif line[3] == 'CALLI':
			if option == 't':
				error_and_exit("Instruction CALLI does not exist in plain TOY ", str(line[0]), str(line[5]))
			elif option == 's':
				error_and_exit("Instruction CALLI does not exist in S-TOY ", str(line[0]), str(line[5]))
			elif option == 'l':
				error_and_exit("Instruction CALLI does not exist in L-TOY ", str(line[0]), str(line[5]))
			else:
				machinecode = "080" + str(hex(line[4]))[2:3]
				line.insert(0, machinecode)
	
		elif line[3] == 'XCH':
			if option == 't':
				error_and_exit("Instruction XCH does not exist in plain TOY ", str(line[0]), str(line[3]))
			elif option == 's':
				error_and_exit("Instruction XCH does not exist in S-TOY ", str(line[0]), str(line[3]))
			else:	
				machinecode = "09" + str(hex(line[4]))[2:3] + str(hex(line[5]))[2:3]
				line.insert(0, machinecode)

		elif line[3] == 'BZI':
			if option == 't':
				error_and_exit("Instruction BZI does not exist in plain TOY ", str(line[0]), str(line[3]))
			elif option == 's':
				error_and_exit("Instruction BZI does not exist in S-TOY ", str(line[0]), str(line[3]))
			else:	
				machinecode = "0d" + str(hex(line[4]))[2:3] + str(hex(line[5]))[2:3]
				line.insert(0, machinecode)

	elif line[3] == 'DW':
		machinecode = hex(int(line[4], 0))[2:].zfill(4) 
		line.insert(0, machinecode)

	elif line[3] == 'DWC':
		machinecode = hex(int(line[4], 0))[2:].zfill(4) 
		line.insert(0, machinecode)
		
	elif line[3] == 'DUP':
		line.insert(0, "xxxx")

	elif line[2] == 'ORG':
		line.insert(0, "xxxx")

if LOGGING == 1:
    logging.debug("code after fourth round is ")
    logging.debug(code)			
    logging.debug("producing output with machine code: ")


#########################################################
# fifth pass: print machine code to standard output
#########################################################
for line in code:
	if prettyprint == 1:
		if line[0] != "xxxx":
			if option != 'xl':
				print (str(hex(line[2]))[2:].zfill(2) + ": " + str(line[0])).upper(),
			else:
				print (str(hex(line[2]))[2:].zfill(4) + ": " + str(line[0])).upper(), 
		elif line[3] == "ORG":
			if option != 'xl':
				print "\n\t",
			else:
				print "\n\t\t",
		elif line[4] == "DUP":
			if option != 'xl':
				print (str(hex(line[2]))[2:].zfill(2)).upper() + ": 0000",
			else:
				print (str(hex(line[2]))[2:].zfill(4)).upper() + ": 0000",
		l = line[len(line)-1]
		if l[len(l)-1] == "\n":
			l = l[:-1]
		print "\t;  " + l
	else:
		if line[0] != "xxxx":
			if option != 'xl':
				print (str(hex(line[2]))[2:].zfill(2) + ": " + str(line[0])).upper()
			else:
				print (str(hex(line[2]))[2:].zfill(4) + ": " + str(line[0])).upper()
           
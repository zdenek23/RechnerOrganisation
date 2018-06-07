import sys

addr = 0

print "v2.0 raw"

for line in sys.stdin:
    while (int(line[:2], 16) != addr and addr <= 255):
        string = str(hex(addr))[2:].zfill(2)
        print "0000"
        addr = addr + 1

    print line[4:],
    addr = addr + 1
        
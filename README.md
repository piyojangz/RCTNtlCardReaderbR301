# npm i react-native-ntl-cardreader --save



#ref
#! /usr/bin/env python
# Jane.
# 2013-11-08 (Y-m-d)
# apt-get install pcscd python-pyscard

from smartcard.System import readers
import binascii

# Thailand ID Smartcard
# define the APDUs used in this script

# Reset
SELECT = [0x00, 0xA4, 0x04, 0x00, 0x08, 0xA0, 0x00, 0x00, 0x00, 0x54, 0x48, 0x00, 0x01]

# CID
COMMAND1 = [0x80, 0xb0, 0x00, 0x04, 0x02, 0x00, 0x0d]
COMMAND2 = [0x00, 0xc0, 0x00, 0x00, 0x0d]

# Fullname Thai + Eng + BirthDate + Sex
COMMAND3 = [0x80, 0xb0, 0x00, 0x11, 0x02, 0x00, 0xd1]
COMMAND4 = [0x00, 0xc0, 0x00, 0x00, 0xd1]

# Address
COMMAND5 = [0x80, 0xb0, 0x15, 0x79, 0x02, 0x00, 0x64]
COMMAND6 = [0x00, 0xc0, 0x00, 0x00, 0x64]

# issue/expire
COMMAND7 = [0x80, 0xb0, 0x01, 0x67, 0x02, 0x00, 0x12]
COMMAND8 = [0x00, 0xc0, 0x00, 0x00, 0x12]
# get all the available readers
r = readers()
print "Available readers:", r

reader = r[0]
print "Using:", reader

connection = reader.createConnection()
connection.connect()

# Reset
data, sw1, sw2 = connection.transmit(SELECT)
print data
print "Select Applet: %02X %02X" % (sw1, sw2)

data, sw1, sw2 = connection.transmit(COMMAND1)
print data
print "Command1: %02X %02X" % (sw1, sw2)

# CID
data, sw1, sw2 = connection.transmit(COMMAND2)
print data
for d in data:
    print chr(d),
    print
print "Command2: %02X %02X" % (sw1, sw2)

# Fullname Thai + Eng + BirthDate + Sex
data, sw1, sw2 = connection.transmit(COMMAND3)
print data
print "Command3: %02X %02X" % (sw1, sw2)

data, sw1, sw2 = connection.transmit(COMMAND4)
print data
for d in data:
    print unicode(chr(d),"tis-620"),
    print
print "Command4: %02X %02X" % (sw1, sw2)

# Address
data, sw1, sw2 = connection.transmit(COMMAND5)
print data
print "Command5: %02X %02X" % (sw1, sw2)

data, sw1, sw2 = connection.transmit(COMMAND6)
print data
for d in data:
    print unicode(chr(d),"tis-620"),
    print
print "Command6: %02X %02X" % (sw1, sw2)

# issue/expire
data, sw1, sw2 = connection.transmit(COMMAND7)
print data
print "Command7: %02X %02X" % (sw1, sw2)

data, sw1, sw2 = connection.transmit(COMMAND8)
print data
for d in data:
    print unicode(chr(d),"tis-620"),
    print
print "Command8: %02X %02X" % (sw1, sw2)

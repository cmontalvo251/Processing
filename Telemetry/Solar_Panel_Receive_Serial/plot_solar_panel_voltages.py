#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt
import sys

if len(sys.argv) > 1:
    data = np.loadtxt(sys.argv[1],delimiter=',') #Test data here
else:
    print('Need name of input file')
    sys.exit()

print(np.shape(data))

hour = data[:,0]
hour[hour>12] = hour[hour>12] - 12 - 12
minute = data[:,1]
second = data[:,2]
time = hour + minute/60. + second/3600.

load = data[:,3]
battery = data[:,4]
solar = data[:,5]

plt.figure()
plt.plot(time,load,'b-',label='Load')
plt.plot(time,battery,'r-',label='Battery')
plt.plot(time,solar,'g-',label='Solar')
plt.legend()
plt.grid()
plt.xlabel('Time (hours)')
plt.ylabel('Voltage')
#plt.ylim([3,3.3])
plt.show()

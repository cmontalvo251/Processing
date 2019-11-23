import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt('Logging_2019_11_23_13_36_53.txt',delimiter=',') #Test data here

print(np.shape(data))

hour = data[:,0]
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
plt.ylim([3,5])
plt.show()
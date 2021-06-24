import numpy as np
import matplotlib.pyplot as plt

#data = np.loadtxt('/home/carlos/Desktop/Logging_2021_3_30_13_35_12.txt')
data = np.loadtxt('Logging_2021_4_6_14_52_20.txt')

roll = data[:,0]
pitch = data[:,1]
yaw = data[:,2]
lon = data[:,3]
lat = data[:,4]
alt = data[:,5]
time = data[:,6]

plt.plot(time,roll)
plt.plot(time,pitch)

##strip -99s
timeGPS1 = time[lon!=-99]
lonGPS1 = lon[lon!=-99]
latGPS1 = lat[lat!=-99]
altGPS1 = alt[alt!=-99]

timeGPS = timeGPS1[lonGPS1!=0]
lonGPS = lonGPS1[lonGPS1!=0]
latGPS = latGPS1[latGPS1!=0]
altGPS = altGPS1[altGPS1!=0]

plt.figure()
plt.plot(lonGPS,latGPS)

plt.figure()
plt.plot(timeGPS,altGPS)

plt.show()

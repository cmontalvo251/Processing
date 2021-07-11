import numpy as np
import matplotlib.pyplot as plt

#data = np.loadtxt('/home/carlos/Desktop/Logging_2021_3_30_13_35_12.txt')
data = np.loadtxt('Logging_2021_4_6_14_52_20.txt')

[r,c] = np.shape(data)
for x in range(0,r):
	plt.figure()
	plt.plot(data[x,:])


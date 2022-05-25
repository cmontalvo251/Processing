import numpy as np
import matplotlib.pyplot as plt
from pdf import PDF

#data = np.loadtxt('/home/carlos/Desktop/Logging_2021_3_30_13_35_12.txt')
filename = 'Logging_2022_5_17_11_18_3.txt'
data = np.loadtxt(filename)

pp = PDF(0,plt)

[r,c] = np.shape(data)
for x in range(0,c):
        print(x)
        plt.figure()
        plt.plot(data[:,x])
        pp.savefig()

pp.close()


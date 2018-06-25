#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

fic = 'energy_for_stalta.bin'
data = np.fromfile(fic,np.float32)

plt.plot(data)
plt.show()



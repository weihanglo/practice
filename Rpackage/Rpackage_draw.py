#---------------------------------------
# 20151010 Data Visualization - Count downloads of R packages
#
# Data: 20151010 web crawling data (R packages download counts)
#---------------------------------------
from pickle import load
import matplotlib.pyplot as plt

with open("Rpackage.pickle", "rb") as file:
    pkg = load(file)

# Extract dowloads above 1 million
freq_pkg = {key: pkg.get(key, None) for key in pkg.keys() if pkg[key] > 1000000}

# Sort data
pkglist = sorted(freq_pkg, key=freq_pkg.get, reverse=True)
pkgdownload = sorted(freq_pkg.values(), reverse=True)

"""
# Another Way to sort dictonary by value:

import operator
x = {'a': 2, 'b': 4, 'c': 3, 'd': 1, 'e': 0}
sorted_x = sorted(x.items(), key=operator.itemgetter(1))

# This will turn dict to pair of tuple.
"""

# Plot
plt.bar(range(len(pkglist)), pkgdownload)
plt.xticks(range(len(pkglist)), pkglist, rotation = 25)
plt.title("Download Counts of Popular R Packages")
plt.grid(True)
plt.show()

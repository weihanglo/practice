#--------------------------------------
# 20151010 Web Crawler Practice - python
#--------------------------------------
import requests, zlib, pickle
from bs4 import BeautifulSoup
from io import StringIO
from pandas import DataFrame

#-----Process url connection-----
url = 'http://cran-logs.rstudio.com/'
 
# http request
res = requests.get(url)      

# Parse
soup = BeautifulSoup(res.text)
soup_link = soup.select("div.span12 > ul li a")

# Empty dictionary
pkg = {}


#-----Main processing loop-----
while len(soup_link) > 0:
    link = soup_link.pop(0)
    try:
        # Get all links
        res = requests.get(url + link.get('href'))
        data = zlib.decompress(res.content, 16+zlib.MAX_WBITS).decode("utf-8")
        # Handle data as a file in memory buffer
        data = StringIO(data)
        # To pandas dataframe, then extract 'package' column
        df = DataFrame.from_csv(data, sep=",", parse_dates=False)['package']
        print("Processing data on {}".format(link.text))
        pkg_temp = df.groupby(df).count().to_dict()
        # Count downloads of each package
        for key in pkg_temp.keys():
            if key in pkg.keys():
                pkg[key] += pkg_temp[key]
            else:
                pkg.update({key: pkg_temp[key]})
    except KeyboardInterrupt:
        raise
    except:
        continue

print("Dumping file into 'pkg.pickle'")
with open('pkg.pickle', 'wb') as file:
    pickle.dump(pkg, file)

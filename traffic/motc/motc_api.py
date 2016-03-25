# -*- coding: utf-8 -*-
import requests, io, re
from bs4 import BeautifulSoup

# MOTC layer ---------------------------
url = 'https://gist.motc.gov.tw/MapDataService/Retrieval'
resp = requests.get(url, verify = False)
layer = re.findall('"LayerName":"(.*?)"', resp.text)

with open('layer.txt', 'w') as f:
    for text in layer:
        f.write('{}\n'.format(text))


# MOTC Web API -------------------------

url = 'https://gist.motc.gov.tw/MapDataService/'

css_h1 = '#tab-1 > div > h1'
css_p = '#tab-1 > div > p:nth-of-type(2)'

h1 = []
p = []

msg ="""BufferApi
LocatorApi
GeoDataApi
QueryCodeApi
AuthApi
"""
buf = io.StringIO(msg)
APIs = buf.read().splitlines()

for API in APIs:
    api_url = url + API
    resp = requests.get(api_url, verify = False)
    soup = BeautifulSoup(resp.text)
    h1_nodes = soup.select(css_h1)
    p_nodes = soup.select(css_p)
    
    for item in h1_nodes:
        print(item.get_text())
        h1.append(item.get_text())
    
    for item in p_nodes:
        p.append(item.get_text())

with open('API.txt', 'w') as f:
    for i, j in zip(h1, p):
        print(i, j)
        f.write('---------{}\n'.format(i))
        f.write('{}\n\n'.format(j))

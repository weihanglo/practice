# -*- coding: utf-8 -*-
import requests
import parser
from bs4 import BeautifulSoup

url = 'http://gra108.aca.ntu.edu.tw/regchk/stu_query.asp'
resp = requests.get(url)
soup = BeautifulSoup(resp.text)
options = [op.get('value') for op in soup.select('select option')]

for opt in options:
    payload = {'qry': '查詢', 'DEP': opt}
    resp2 = requests.post(url, data=payload)
    soup2 = BeautifulSoup(resp2.text)
    table = soup2.select_one('table')
    parser.html_table(table, opt + '.csv')
    print("Get %s.csv" % opt)


#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import logging
import re
import requests
import sys
import time
from operator import itemgetter
from bs4 import BeautifulSoup

def QueryGenerator(query, Min=0, Max=999999):
    """
    Returns :: a generator which yields query results in JSON format.

    :query: product to query at http://24h.pchome.com.tw
    :Min: minimum of price range
    :Max: maximum of price range

    """
    url = 'http://ecshweb.pchome.com.tw/search/v3.3/all/results'
    params = {
            'q': query,
            'page': 0,
            'sort': 'rnk/dc',
            'price': '{}-{}'.format(Min, Max),
    }
    while True:
        params['page'] += 1
        try:
            r_json = requests.get(url, params=params).json()
            if params['page'] == r_json.get('totalPage'):
                break
        except:
            logging.error('Error on page {}: {} at {}'.format(params['page'], \
                sys.exc_info(), time.strftime('%Y-%m-%d %H:%M:%S %Z')))
        else:
            logging.info('Succeed on page {} at {}'.format(params['page'], \
                time.strftime('%Y-%m-%d %H:%M:%S %Z')))
            yield r_json.get('prods')

def DetailGenerator(IdList, Type):
    """
    Returns :: a generator which yields query details in JSON format.

    :IdList: list of product Ids from http://24h.pchome.com.tw/
    :Type: string of query type ('desc' or 'prod')

    """
    while IdList:
        N = 30
        Ids = IdList[:N]
        del IdList[:N]
        prodApi = 'http://ecapi.pchome.com.tw/ecshop/prodapi/v2/prod'
        p = re.compile(r'(?:jsonp\w*_\w+\()(.*)(?=\);}catch\(e\))')
        Idjoin = ','.join(Ids)
        query = {
            'desc': '/desc&id={}&fields=Id,Stmt,Slogan&_callback=jsonp_desc',
            'prod': ('?id={}&fields=Id,Name,Nick,Price,Pic,Qty,Bonus&'
                '_callback=jsonpcb_prodecshop'),
        }[Type]
        url = prodApi + query.format(Idjoin)
        try:
            r = requests.get(url)
            s = BeautifulSoup(r.text, 'lxml')
            jsonp = s.text
            m = p.search(jsonp)
            output = json.loads(m.group(1))
        except:
            logging.error('Ids {}. Error: {} at {}'.format(Idjoin, \
                sys.exc_info(), time.strftime('%Y-%m-%d %H:%M:%S %Z')))
        else:
            logging.info('{} record succeed at {}'.format(N, \
                time.strftime('%Y-%m-%d %H:%M:%S %Z')))
            yield output.values()

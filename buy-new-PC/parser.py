#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pymongo import MongoClient

uri = 'mongodb://localhost:27017/'
client = MongoClient(uri)
db = client.pchome
cur = db.details.find({'Stmt': {'$regex': '處理器.*記憶體', '$options': 'sm'}})

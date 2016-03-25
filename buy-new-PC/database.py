#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import random
import re
import sys
import time
from datetime import datetime
from pymongo import MongoClient
from connector import QueryGenerator
from connector import DetailGenerator

def database(generator, collection, update=False):
    """
    Returns :: none

    :generator: a generator which yields product profile in JSON format
    :collection: a pymongo.collection.Collection class object

    """
    for JSON in generator:
        for J in JSON:
            J['modified_time'] = datetime.now()
            if not update:
                result = collection.insert_one(J)
                logging.info('Inserted: ({})'.format(result.inserted_id))
            else:
                result = collection.update_one(
                    {'Id': re.sub(r'-\d+', '', J['Id'])}, {'$set': J})
                logging.info('Updated: ({})'.format(result.upserted_id
                    if result.upserted_id else 'Id: {}'.format(J['Id']) if 
                        result.modified_count else 'Failed at {}'.format(
                            J['Id'])))
        time.sleep(random.random() * 4 + 1)

def main(args):
    uri = 'mongodb://localhost:27017/'
    client = MongoClient(uri)
    db = client.pchome
    if args:
        assert len(args) == 3
        key = ['query', 'Min', 'Max']
        kwargs = dict(zip(key, args))
        generator = QueryGenerator(**kwargs)
        database(generator, db.profiles, update=False)
    else:
        IdList = db.profiles.distinct('Id')
        desc_gen = DetailGenerator(IdList[:], 'desc')
        prod_gen = DetailGenerator(IdList[:], 'prod')
        database(desc_gen, db.details, update=False)
        database(prod_gen, db.details, update=True)

if __name__ == '__main__':
    logging.basicConfig(filename='pchome-details.log', level=logging.DEBUG)
    logging.info('Started at {}'.format(time.strftime('%Y-%m-%d %H:%M:%S %Z')))
    main(sys.argv[1:])
    logging.info('Finished at {}'.format(time.strftime('%Y-%m-%d %H:%M:%S %Z')))

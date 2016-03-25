#!/bin/bash


brands="asus acer hp toshiba lenovo dell apple ideapad msi gigabyte fujitsu"
for brand in $brands; do
    echo do $brand
    python3 database.py $brand 5000 500000
done

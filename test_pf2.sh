#!/bin/bash
set -e

# In het lab gebruiken ze vaak 172.17.0.1 (docker host).
# Op sommige systemen werkt localhost ook.
URL1="http://172.17.0.1:5050/login"
URL2="http://localhost:5050/login"

if curl -s $URL1 | grep -q "User Login"; then
  exit 0
elif curl -s $URL2 | grep -q "User Login"; then
  exit 0
else
  exit 1
fi

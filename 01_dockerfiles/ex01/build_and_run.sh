#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t ex01 $BASEDIR
docker run -d --name ts_server -p 9987:9987/udp -p 30033:30033 -p 10011:10011 ex01

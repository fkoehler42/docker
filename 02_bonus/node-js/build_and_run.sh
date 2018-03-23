#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t node-app $BASEDIR
docker run -d --name node-app-sample -p 49160:8080 node-app
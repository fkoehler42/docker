#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t json-c $BASEDIR
docker run -it --name json-c-sample json-c
#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t ex00 $BASEDIR
docker run -it --name vim-container ex00

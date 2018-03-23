#!/bin/bash

BASEDIR=$(dirname "$0")"/"

docker build -t php-server $BASEDIR
docker run -d --name php-sample -p 8080:80 php-server
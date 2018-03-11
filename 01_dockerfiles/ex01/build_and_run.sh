#!/bin/bash
docker build -t ex01 ~/projects/docker/01_dockerfiles/ex01
docker run -it --name ts_server -p 9987:9987/udp -p 30033:30033 -p 10011:10011 ex01

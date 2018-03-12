#!/bin/bash
docker build -t ex00 ~/projects/docker/01_dockerfiles/ex00
docker run -it --name vim-container ex00

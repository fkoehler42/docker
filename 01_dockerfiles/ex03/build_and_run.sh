#!/bin/bash
docker build -t gitlab-ce ~/projects/docker/01_dockerfiles/ex03
docker run -it --name ex03 -p 443:443 -p 80:80 -p 22:22 gitlab-ce

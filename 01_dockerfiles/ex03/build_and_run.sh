#!/bin/bash
docker build -t gitlab-ce ~/projects/docker/01_dockerfiles/ex03
# port 22 already used (default ssh) so we set 2222
docker run -it --name ex03 -p 443:443 -p 80:80 -p 2222:22 gitlab-ce

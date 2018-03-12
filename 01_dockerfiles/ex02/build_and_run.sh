#!/bin/bash
docker build -t ft-rails:on-build ~/projects/docker/01_dockerfiles/ex02
docker build -t ex02 ~/projects/docker/01_dockerfiles/ex02/app
docker run -d --name rails-app -p 3000:3000 ex02

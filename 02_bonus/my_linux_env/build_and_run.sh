#!/bin/bash
docker build -t my_linux_env ~/projects/docker/02_bonus/my_linux_env
docker run -it --name my_linux my_linux_env

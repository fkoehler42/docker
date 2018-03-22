#!/bin/bash
docker build -t json-c ~/projects/docker/02_bonus/json-c
docker run -it --name json-c-sample json-c
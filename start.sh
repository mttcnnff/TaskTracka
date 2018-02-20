#!/bin/bash

export PORT=5300
export MIX_ENV=prod

cd ~/www/TaskTracka
./bin/tasktracka stop || true
./bin/tasktracka start

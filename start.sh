#!/bin/bash

export PORT=5300

cd ~/www/TaskTracka
./bin/tasktracka stop || true
./bin/tasktracka start

#!/bin/bash

export PORT=5300

cd ~/www/TaskTracka
./bin/TaskTracka stop || true
./bin/TaskTracka start

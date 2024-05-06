#!/bin/bash

if [ $# -eq 0 ]; then
  echo 'Need file name'
  exit 1
fi

hugo new --kind post post/$1.md
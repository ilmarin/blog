#!/bin/bash

if [ $# -eq 0 ]; then
  echo 'Need file name'
  exit 1
fi

vim content/post/$1.md

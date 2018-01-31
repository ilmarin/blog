#!/bin/bash

if [ $# -eq 0 ]; then
  echo 'Need file name'
  exit 1
fi

hugo new post/$1.md
vim content/post/$1.md

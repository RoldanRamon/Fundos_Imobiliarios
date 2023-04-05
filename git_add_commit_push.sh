#!/bin/bash

echo "Updating the total dataset"

if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name 'RoldanRamon'
    git config --global user.email 'roldanramon83@gmail.com'
    git add .
    git commit -m "Auto update Dataset"
    git push
fi
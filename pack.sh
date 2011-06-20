#!/bin/sh

cp src/ai/monadkamaboko/monadKamaboko_nc run

tar zvcf icfpc-`date +%s`.tgz `find . -type f | fgrep -v .svn | fgrep -v tgz`

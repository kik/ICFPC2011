#!/bin/sh

cp src/kamaboko run

tar zvcf icfpc-`date +%s`.tgz `find . -type f | fgrep -v .svn | fgrep -v tgz`

#!/bin/bash
source scope-scripts/functions.sh

#all commands are understood to be executed from root of site
#loops are executed from within a given directory and exited upon completion

#------------------------------Global Variables---------------------------------
#for FTP purposes
username=$1
password=$2
domain="codytaylor.cc"

#for github
pages="http://github.com/OKCody/Pages"
#-------------------------------------------------------------------------------

scope-clean
github-clone
markdown-html
dependence-copy
index-build
archive-build
top-level-build
search-build
rss-build
pages-build
#server-upload
echo "Done!"

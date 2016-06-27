#!/bin/bash
source scope-scripts/functions.sh

#ground rules:
#all commands are understood to be executed from root of site
#loops are executed from within a given directory and exited upon completion

#------------------------------Global Variables---------------------------------
#enter domain and username for ssh purposes
domain="codytaylor.cc"
username="codyalantaylor"
#will be prompted for password when script attempts to log into server

#page content to pull down from GitHub
pages="http://github.com/OKCody/Pages"

#necessary in order to pass command line option to function call in "sourced" file
#Surely this can be done in a more elegant way.
if [ "$1" == "--pdf" ] || [ "$2" == "--pdf" ];
then
  let pdf="1";
else
  let pdf="0";
fi

#test for "upload" flag and pass to sourced functions
if [ "$1" == "-u" ] || [ "$2" == "-u" ];
then
  let upload="1";
else
  let upload="0";
fi
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
server-upload;
echo "Done!"

#!/bin/bash
source scope-scripts/functions.sh

#all commands are understood to be executed from root of site
#loops are executed from within a given directory and exited upon completion

#------------------------------Global Variables---------------------------------
#for FTP purposes
domain="codytaylor.cc"

#for github
pages="http://github.com/OKCody/Pages"

#necessary in order to pass command line option to function call in "sourced" file
if [ "$1" == "-pdf" ] || [ "$2" == "-pdf" ];
then
  let pdf="1";
else
  let pdf="0";
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
if [ "$1" == "-u" ] || [ "$2" == "-u" ];
then
  server-upload;
else
  echo "Use -u to upload to server";
fi
echo "Done!"

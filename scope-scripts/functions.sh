#-----------------------------Cleaning up Scope---------------------------------
scope-clean(){
  echo "Cleaning up Scope/ ..."

  #delete site-content directory, will be recreated when cloned
  #delete contents of /root
  rm -rf site-content
  rm -rf root
  mkdir root
}
#-------------------------------------------------------------------------------

#-----------------------------Cleaning up Site----------------------------------
site-clean(){
  echo "Cleaning up Site/ ..."

  cd $site_root
  #remove all files from site's root directory except images/ and legacy-images/
  rm -rf $(ls -I images -I legacy-images)
  cd ~/Scope
}
#-------------------------------------------------------------------------------


#--------------------------Clone pages from GitHub------------------------------
github-clone() {
  echo "Cloning Pages/ from Github ..."

  #pull down most current version of all site entries
  git clone -q $pages

  #rename cloned directory to fit schema
  mv Pages site-content
}
#-------------------------------------------------------------------------------

#----------------------------.md --> .html--------------------------------------
markdown-html(){
  echo "Converting .md files to .html ..."

  cd site-content
  #run markdown.pl script to convert .md files to .html
  for filename in *.md
  do
  pandoc -f markdown -t html -o ${filename%.md}.html $filename
  #  perl ../scope-scripts/Markdown.pl $filename > ${filename%.md}.html
  # scholdoc $filename -o ${filename%.md}.html
  done
  cd ..
}
#-------------------------------------------------------------------------------

#---------------------------Root directory prep.--------------------------------
dependence-copy(){
  echo "Copying dependent files into root directory ..."
  #copy style and images from Scope/ into root/ to be pushed to server
  mkdir root/style
  mkdir root/scope-images
  mkdir root/scope-images/license
  mkdir root/archive

  cd scope-style
  for filename in *.css
  do
    cp $filename ../root/style/$filename
  done
  cd ..

  cd scope-images
  for filename in *.???
  do
    cp $filename ../root/scope-images/$filename
  done
  cd ..

  cd scope-images/license
  for filename in *
  do
    cp $filename ../../root/scope-images/license/$filename
  done
  cd ../..
}
#-------------------------------------------------------------------------------


#----------------------------Create index.html----------------------------------
index-build(){
  echo "Building index.html ..."

  cd site-content
  for filename in *.html
  do
    month=${filename:4:2}
    day=${filename:6:2}
    year=${filename:0:4}
    title=${filename:9}
    title=${title%.html}
    address=$title
    title=${title//_/ }

    if [ $month == "01" ]; then month="Jan"; fi
    if [ $month == "02" ]; then month="Feb"; fi
    if [ $month == "03" ]; then month="Mar"; fi
    if [ $month == "04" ]; then month="Apr"; fi
    if [ $month == "05" ]; then month="May"; fi
    if [ $month == "06" ]; then month="Jun"; fi
    if [ $month == "07" ]; then month="Jul"; fi
    if [ $month == "08" ]; then month="Aug"; fi
    if [ $month == "09" ]; then month="Sep"; fi
    if [ $month == "10" ]; then month="Oct"; fi
    if [ $month == "11" ]; then month="Nov"; fi
    if [ $month == "12" ]; then month="Dec"; fi

    title="<h1>$title</h1>"
    date="<p>$month $day, $year</p>"

    #concatenate contents of head.html, $filename.html, and tail.html and write to
    #file in archive directory
    cat ../scope-template/head.html > ../root/archive/$filename
    echo $title >> ../root/archive/$filename
    echo $date >> ../root/archive/$filename
    cat $filename >> ../root/archive/$filename
    cat ../scope-template/tail.html >> ../root/archive/$filename
  done
  cd ..

  #create index.html from most recent file in root/ based -i '' on date at front of filename
  #yyyymmmdd_filename.html
  #prepending date to filename in this way forces most recent page to bottom of ls
  index=$(ls root/archive/*.html | tail -n1)
  cp $index root/index.html

  if [ $OSTYPE == "linux-gnu" ];
  then
    sed -i "s/<title><\/title>/<title>Cody Taylor<\/title>/g ; s/.html<\/title>/<\/title>/g" root/index.html
  else
    sed -i '' "s/<title><\/title>/<title>Cody Taylor<\/title>/g ; s/.html<\/title>/<\/title>/g" root/index.html
  fi
  #change path to /scope-style as it is different for index.html than it is for all other pages.
  #sed -i '' "" "s/..\/..\/style\/normalize.css/style\/normalize.css/g" root/index.html
  #sed -i '' "" "s/..\/..\/style\/skeleton.css/style\/skeleton.css/g" root/index.html
  #sed -i '' "" "s/..\/..\/style\/style.css/style\/style.css/g" root/index.html
  #sed -i '' "" "s/..\/..\/style\/print.css/style\/print.css/g" root/index.html
}
#-------------------------------------------------------------------------------

#------------------------------Create Archive-----------------------------------
archive-build(){
  echo "Building archive/index.html ..."

  cd site-content
  #building file from bottom up so that most recent page appears at top
  cat ../scope-template/tail.html > ../root/archive/index.html
  for filename in *.html
  do
    month=${filename:4:2}
    day=${filename:6:2}
    year=${filename:0:4}
    filename=${filename:9}
    filename=${filename%.html}
    address=$filename
    filename=${filename//_/ }

    if [ $month == "01" ]; then month="January"; fi
    if [ $month == "02" ]; then month="February"; fi
    if [ $month == "03" ]; then month="March"; fi
    if [ $month == "04" ]; then month="April"; fi
    if [ $month == "05" ]; then month="May"; fi
    if [ $month == "06" ]; then month="June"; fi
    if [ $month == "07" ]; then month="July"; fi
    if [ $month == "08" ]; then month="August"; fi
    if [ $month == "09" ]; then month="September"; fi
    if [ $month == "10" ]; then month="October"; fi
    if [ $month == "11" ]; then month="November"; fi
    if [ $month == "12" ]; then month="December"; fi

    echo -e "\n$(cat ../root/archive/index.html)" > ../root/archive/index.html
    echo -e "<p class='archive'>$month $day, $year</p>\n$(cat ../root/archive/index.html)" > ../root/archive/index.html
    echo -e "<a href='$address'><h2 class='archive-title'>$filename</h2></a>\n$(cat ../root/archive/index.html)" > ../root/archive/index.html

  done
  echo -e "$(cat ../scope-template/head.html)\n<h1 style='margin-bottom: 60px;'>Archive</h1>$(cat ../root/archive/index.html)" > ../root/archive/index.html
  cd ..

  if [ $OSTYPE == "linux-gnu" ];
  then
    sed -i "s/<title><\/title>/<title>Archive<\/title>/g ; s/.html<\/title>/<\/title>/g" root/archive/index.html
  else
    sed -i '' "s/<title><\/title>/<title>Archive<\/title>/g ; s/.html<\/title>/<\/title>/g" root/archive/index.html
  fi

  #change path to /scope-style as it is different for archive/index.html than it is for all other pages.
  #sed -i '' "" "s/..\/..\/style\/normalize.css/..\/style\/normalize.css/g" root/archive/index.html
  #sed -i '' "" "s/..\/..\/style\/skeleton.css/..\/style\/skeleton.css/g" root/archive/index.html
  #sed -i '' "" "s/..\/..\/style\/style.css/..\/style\/style.css/g" root/archive/index.html
  #sed -i '' "" "s/..\/..\/style\/print.css/..\/style\/print.css/g" root/archive/index.html
}
#-------------------------------------------------------------------------------

#--------------------------Create Top-Level Pages-------------------------------
#does not currently get indexed by search
#perhaps it should in the future
top-level-build(){
  echo "Building top-level pages ..."

  #convert top-level markdown content to html
  cd site-content/top-level
  for filename in *.md
  do
    pandoc $filename -o ${filename%.md}.html
    # scholdoc $filename -o ${filename%.md}.html
  done

  for filename in *.html
  do
    #concatenate contents of head.html, $filename.html, and tail.html and write to
    #file in top-level directory
    echo > ../../$filename
    cat ../../scope-template/head.html $filename ../../scope-template/tail.html > ../../root/$filename
  done
  cd ../../
}
#-------------------------------------------------------------------------------

#---------------------------Creating Search Index-------------------------------
search-build(){
  echo "Building search index and search results page ..."

  mkdir root/tipuesearch
  cp -r tipuesearch/. root/tipuesearch/
  cp root/tipuesearch/search.html root/search.html
  #echo " - Directories reated!"

  echo "var tipuesearch = {\"pages\": [" > root/tipuesearch/tipuesearch_content.js
  #echo " - Empty file created!"
  cd site-content

  for filename in *.html
  do
    longfilename=$filename
    filename=${filename:9}
    filename=${filename%.html}
    address=$filename
    filename=${filename//_/ }

    text=$(sed -e 's/<[^>]*>//g' $longfilename)
    text=$(echo $text|tr -d '\n')
    text=$(echo $text|tr -d '"')

    echo "   {\"title\": \"$filename\", \"text\": \"$text\", \"tags\": \"\", \"url\": \"http://$domain/archive/$address\"}," >> ../root/tipuesearch/tipuesearch_content.js
  done

  if [ $OSTYPE == "linux-gnu" ];
  then
    echo "$(sed '$ s/.$//' ../root/tipuesearch/tipuesearch_content.js)" > ../root/tipuesearch/tipuesearch_content.js
    echo "]};" >> ../root/tipuesearch/tipuesearch_content.js
  else
    echo "$(sed '$ s/.$//' ../root/tipuesearch/tipuesearch_content.js)" > ../root/tipuesearch/tipuesearch_content.js
    echo "]};" >> ../root/tipuesearch/tipuesearch_content.js
  fi

  cd ..
}
#-------------------------------------------------------------------------------

#-----------------------------Creating RSS File---------------------------------
rss-build(){
  echo "Building RSS file ..."

  cd site-content

  echo "<?xml version=\"1.0\" ?>" > ../root/feed.xml
  echo "<rss version=\"2.0\">" >> ../root/feed.xml
  echo "<channel>" >> ../root/feed.xml
  echo "<title>Cody Taylor</title>" >> ../root/feed.xml
  echo "<link>http://codytaylor.cc/feed.rss</link>" >> ../root/feed.xml
  echo "<description>Personal projects of Cody Taylor</description>" >> ../root/feed.xml


  for filename in *.html
  do
    month=${filename:4:2}
    day=${filename:6:2}
    year=${filename:0:4}
    title=${filename:9}
    title=${title%.html}
    address=$title
    title=${title//_/ }

    if [ $month == "01" ]; then month="Jan"; fi
    if [ $month == "02" ]; then month="Feb"; fi
    if [ $month == "03" ]; then month="Mar"; fi
    if [ $month == "04" ]; then month="Apr"; fi
    if [ $month == "05" ]; then month="May"; fi
    if [ $month == "06" ]; then month="Jun"; fi
    if [ $month == "07" ]; then month="Jul"; fi
    if [ $month == "08" ]; then month="Aug"; fi
    if [ $month == "09" ]; then month="Sep"; fi
    if [ $month == "10" ]; then month="Oct"; fi
    if [ $month == "11" ]; then month="Nov"; fi
    if [ $month == "12" ]; then month="Dec"; fi

    text=$(sed -i -e 's/<[^>]*>//g' $filename)
    text=$(echo $text|tr -d '\n')
    text=$(echo $text|tr -d '"')

    echo "<item>" >> ../root/feed.xml
    echo "<title>$title</title>" >> ../root/feed.xml
    echo "<link>http://codytaylor.cc/archive/$address/index.html</link>" >> ../root/feed.xml
    echo "<guid>http://codytaylor.cc/archive/$address/index.html</guid>" >> ../root/feed.xml
    echo "<description>${text:0:500}</description>" >> ../root/feed.xml
    echo "<pubDate>$day $month $year</pubDate>" >> ../root/feed.xml
    echo "</item>" >> ../root/feed.xml
  done

  echo "</channel>" >> ../root/feed.xml
  echo "</rss>" >> ../root/feed.xml

  cd ..
}
#-------------------------------------------------------------------------------

#--------------------Prepare public-facing pages and PDFs-----------------------
pages-build(){
  echo "Building page directories and index.html files. Use --pdf to generate PDFs ..."

  cd root/archive
  numfiles=$(find . -type f| wc -l)
  let numfiles-=1
  currentfile=0
  for filename in [!index.html]*.html
  do
    #remove dates from front of filenames in root/
    #from
    #yyyymmmdd_filename.html
    #to
    #filename.html
    #dates on filenames in site-content/ do not matter (not public facing)
    newname=${filename:9}
    newname=${newname%.html}
    let currentfile+=1
    echo "$currentfile of $numfiles : $newname"
    mkdir $newname
    mv $filename $newname/index.html
    #find "<title></title>" in previously created file. replace with <title>$filename</title>
    #replace underscores with spaces and remove ".html" from end of filename
    if [ $OSTYPE == "linux-gnu" ];
    then
      sed -i "s/<title><\/title>/<title>${newname//_/ }<\/title>/g ; s/.html<\/title>/<\/title>/g" $newname/index.html
    else
      sed -i '' "s/<title><\/title>/<title>${newname//_/ }<\/title>/g ; s/.html<\/title>/<\/title>/g" $newname/index.html
    fi
    #necessary because wkhtmltopdf won't use print.css otherwise
    #sed -i '' "s/\/style\/style.css/\/style\/print.css/g" $newname/index.html
    #sed -i '' "s/\/style\/print.css/\/style\/style.css/g" $newname/index.html
    #requires explicit instruction to generate PDFs
    if [ "$pdf" == "1" ] ;
    then
      scholdoc -H ../../scope-style/print.css $newname/index.html -o $newname/temp.html
      wkhtmltopdf --quiet --javascript-delay 1000 $newname/temp.html $newname/print.pdf
      #rm temp.html
      #wkhtmltopdf --quiet --viewport-size 1280x1024 --disable-smart-shrinking --user-style-sheet ../style/print.css $newname/index.html $newname/print.pdf;
    fi
    #The following is a hack to replace names of stylesheets to their proper form.
    #Prior is only so that wkhtmltopdf will use the print.css instead of style.css
  #  sed -i '' -i '' "s/\/style\/print.css/\/style\/style.css/g" $newname/index.html
  #  sed -i '' -i '' "s/\/style\/style.css media=/\/style\/print.css media=/g" $newname/index.html
  done
  cd ../..
}
#-------------------------------------------------------------------------------

#-----------------------------------Move----------------------------------------
server-move(){
  echo "Cleaning site root ..."

  cd $site_root
  #remove all files from site's root directory except images/ and legacy-images/
  rm -rf $(ls -I images -I legacy-images)
  cd ~/Scope

  echo "Moving files to site root ..."

  mv root/* $site_root
}
#-------------------------------------------------------------------------------


#-----------------------------------FTP-----------------------------------------
server-upload(){
  #requires -u flag in order to automatically upload to server
  if [ $upload == "1" ];
  then
    echo "Uploading to server ..."
    path=$(pwd)
    if [ ${path: -5} == "Scope" ];
    then
      cd root;
      zip -r zipfile.zip . -x ".*" -x "/.*";
      echo "Zipped site contents ..."
      scp zipfile.zip $username@$domain:.
      ssh $username@$domain 'rm -r public_html/*; mv zipfile.zip public_html/zipfile.zip; cd public_html; unzip zipfile.zip; rm zipfile.zip; exit;';
      cd ..
    else
      echo "Upload failed: be sure to execute from root of Scope/"
    fi
  else
    echo "Use -u to upload to server";
  fi
}
#-------------------------------------------------------------------------------

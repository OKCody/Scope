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


#--------------------------------Cleaning up------------------------------------
echo "Cleaning up Scope/ ..."

#delete site-content directory, w ill be recreated when cloned
#delete contents of /root
rm -rf site-content
rm -rf root
mkdir root
#-------------------------------------------------------------------------------

#--------------------------Clone pages from GitHub------------------------------
echo "Cloning Pages/ from Github..."

#pull down most current version of all site entries
git clone -q $pages

#rename cloned directory to fit schema
mv Pages site-content
#-------------------------------------------------------------------------------

#----------------------------.md --> .html--------------------------------------
echo "Converting .md files to .html ..."

cd site-content
#run markdown.pl script to convert .md files to .html
for filename in *.md
do
# pandoc -f markdown -t html -o ${filename%.md}.html $filename
  perl ../scope-scripts/Markdown.pl $filename > ${filename%.md}.html
done
cd ..
#-------------------------------------------------------------------------------

#---------------------------Root directory prep.--------------------------------
echo "Copying dependent files into root directory..."
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
#-------------------------------------------------------------------------------


#----------------------------Create index.html----------------------------------
echo "Building index.html ..."

cd site-content
for filename in *.html
do
  #concatenate contents of head.html, $filename.html, and tail.html and write to
  #file in archive directory
  cat ../scope-template/head.html $filename ../scope-template/tail.html > ../root/archive/$filename
done
cd ..

#create index.html from most recent file in root/ based on date at front of filename
#yyyymmmdd_filename.html
#prepending date to filename in this way forces most recent page to bottom of ls
index=$(ls root/archive/*.html | tail -n1)
cp $index root/index.html

sed -i "s/<title><\/title>/<title>Cody Taylor<\/title>/g ; s/.html<\/title>/<\/title>/g" root/index.html
#change path to /scope-style as it is different for index.html than it is for all other pages.
#sed -i "" "s/..\/..\/style\/normalize.css/style\/normalize.css/g" root/index.html
#sed -i "" "s/..\/..\/style\/skeleton.css/style\/skeleton.css/g" root/index.html
#sed -i "" "s/..\/..\/style\/style.css/style\/style.css/g" root/index.html
#sed -i "" "s/..\/..\/style\/print.css/style\/print.css/g" root/index.html
#-------------------------------------------------------------------------------

#------------------------------Create Archive-----------------------------------
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

  echo -e "<br>\n$(cat ../root/archive/index.html)" > ../root/archive/index.html
  echo -e "<p class='archive'>$month $day, $year</p>\n$(cat ../root/archive/index.html)" > ../root/archive/index.html
  echo -e "<a href='$address'><h3 class='archive'>$filename</h3></a>\n$(cat ../root/archive/index.html)" > ../root/archive/index.html

done
echo -e "$(cat ../scope-template/head.html)\n$(cat ../root/archive/index.html)" > ../root/archive/index.html
cd ..

sed -i "s/<title><\/title>/<title>Archive<\/title>/g ; s/.html<\/title>/<\/title>/g" root/archive/index.html
#change path to /scope-style as it is different for archive/index.html than it is for all other pages.
#sed -i "" "s/..\/..\/style\/normalize.css/..\/style\/normalize.css/g" root/archive/index.html
#sed -i "" "s/..\/..\/style\/skeleton.css/..\/style\/skeleton.css/g" root/archive/index.html
#sed -i "" "s/..\/..\/style\/style.css/..\/style\/style.css/g" root/archive/index.html
#sed -i "" "s/..\/..\/style\/print.css/..\/style\/print.css/g" root/archive/index.html
#-------------------------------------------------------------------------------

#---------------------------Creating Search Index-------------------------------
echo "Building search index and search results page..."

mkdir root/tipuesearch
cp -r tipuesearch/. root/tipuesearch/
cp root/tipuesearch/search.html root/search.html

echo "var tipuesearch = {\"pages\": [" > root/tipuesearch/tipuesearch_content.js

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

echo "$(sed '$ s/.$//' ../root/tipuesearch/tipuesearch_content.js)" > ../root/tipuesearch/tipuesearch_content.js
echo "]};" >> ../root/tipuesearch/tipuesearch_content.js

cd ..

#-------------------------------------------------------------------------------

#-----------------------------Creating RSS File---------------------------------
echo "Building RSS file..."

cd site-content

echo > ../root/feed.rss
echo "<?xml version=\"1.0\" ?>" >> ../root/feed.rss
echo "rss version=\"2.0\">" >> ../root/feed.rss
echo "<channel>" >> ../root/feed.rss
echo "<title>Cody Taylor</title>" >> ../root/feed.rss
echo "<link>http://codytaylor.cc/feed.rss</link>" >> ../root/feed.rss
echo "<description>Personal projects of Cody Taylor</description>" >> ../root/feed.rss


for filename in *.html
do
  title=${filename:9}
  title=${title%.html}
  address=$title
  title=${title//_/ }

  text=$(sed -e 's/<[^>]*>//g' $filename)
  text=$(echo $text|tr -d '\n')
  text=$(echo $text|tr -d '"')

  echo "<item>" >> ../root/feed.rss
  echo "<tttle>$title</title>" >> ../root/feed.rss
  echo "<link>http://codytaylor.cc/archive/$address/index.html</link>" >> ../root/feed.rss
  echo "<description>${text:0:1000}</description>" >> ../root/feed.rss
  echo "</item>" >> ../root/feed.rss
done

echo "</channel>" >> ../root/feed.rss
echo "</rss>" >> ../root/feed.rss
#-------------------------------------------------------------------------------

#--------------------Prepare public-facing pages and PDFs-----------------------
echo "Building page directories; index.html and print.pdf for each..."

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
  sed -i "s/<title><\/title>/<title>${newname//_/ }<\/title>/g ; s/.html<\/title>/<\/title>/g" $newname/index.html
  #necessary because wkhtmltopdf won't use print.css otherwise
#  sed -i "s/\/style\/style.css/\/style\/print.css/g" $newname/index.html
  #sed -i "s/\/style\/print.css/\/style\/style.css/g" $newname/index.html
  wkhtmltopdf --quiet --viewport-size 1280x1024 --disable-smart-shrinking --user-style-sheet ../style/print.css $newname/index.html $newname/print.pdf
  #The following is a hack to replace names of stylesheets to their proper form.
  #Prior is only so that wkhtmltopdf will use the print.css instead of style.css
#  sed -i "s/\/style\/print.css/\/style\/style.css/g" $newname/index.html
#  sed -i "s/\/style\/style.css media=/\/style\/print.css media=/g" $newname/index.html
done
cd ../..
#-------------------------------------------------------------------------------

#-----------------------------------FTP-----------------------------------------
echo "Uploading to server ..."

path=$(pwd)
if [ ${path: -5} == "Scope" ];
then
  cd root;
  zip -r zipfile.zip . -x ".*" -x "/.*";
  echo "Zipped site contents ..."
  scp zipfile.zip codyalantaylor@codytaylor.cc:.
  ssh codyalantaylor@codytaylor.cc 'rm -r public_html/*; mv zipfile.zip public_html/zipfile.zip; cd public_html; unzip zipfile.zip; rm zipfile.zip; exit;';
  cd ..
else
  echo "Upload failed: be sure to execute from root of Scope/"
fi
#-------------------------------------------------------------------------------


echo "Done!"

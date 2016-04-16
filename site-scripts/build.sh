#all commands are understood to be executed from root of site
#loop are executed from within a given directory and exited upon completion

#--------------------------------Cleaning up------------------------------------
echo "Cleaning up Scope/ ..."

#delete site-content directory, w ill be recreated when cloned
#delete contents of /contents
rm -rf site-content
rm -rf content
mkdir content
#-------------------------------------------------------------------------------

#--------------------------Clone pages from GitHub------------------------------
echo "Cloning Pages/ from Github..."

#pull down most current version of all site entries
git clone -q http://github.com/OKCody/Pages

#rename cloned directory to fit schema
mv Pages site-content
#-------------------------------------------------------------------------------

#----------------------------.md --> .html--------------------------------------
echo "Converting .md files to .html ..."

cd site-content
#run markdown.pl script to convert .md files to .html
for filename in *.md
do
  perl ../site-scripts/Markdown.pl $filename > ${filename%.md}.html
done
cd ..
#-------------------------------------------------------------------------------

#---------------------------Home directory prep.--------------------------------
echo "Copying dependent files into root directory..."
#copy style and images from Scope/ into content/ to be pushed to server
mkdir content/style
mkdir content/site-images
mkdir content/site-images/license

cd site-style
for filename in *.css
do
  cp $filename ../content/style/$filename
done
cd ..

cd site-images
for filename in *.???
do
  cp $filename ../content/site-images/$filename
done
cd ..

cd site-images/license
for filename in *
do
  cp $filename ../../content/site-images/license/$filename
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
  cat ../site-template/head.html $filename ../site-template/tail.html > ../content/$filename
done
cd ..

#create index.html from most recent file in /content based on date at front of filename
#yyyymmmdd_filename.html
#prepending date to filename in this way forces most recent page to bottom of ls
index=$(ls content/*.html | tail -n1)
mv $index content/index.html

sed -i "s/<title><\/title>/<title>Cody Taylor<\/title>/g ; s/.html<\/title>/<\/title>/g" content/index.html
#change path to /site-style as it is different for index.html than it is for all other pages.
sed -i "s/..\/style\/normalize.css/style\/normalize.css/g" content/index.html
sed -i "s/..\/style\/skeleton.css/style\/skeleton.css/g" content/index.html
sed -i "s/..\/style\/style.css/style\/style.css/g" content/index.html
sed -i "s/..\/style\/print.css/style\/print.css/g" content/index.html
#-------------------------------------------------------------------------------

#--------------------Prepare public-facing pages and PDFs-----------------------
echo "Creating page directories; index.html and print.pdf for each..."

cd content
numfiles=$(find -maxdepth 1 -type f | wc -l)
currentfile=0
for filename in [!index.html]*.html
do
  #remove dates from front of filenames in content/
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
  sed -i "s/..\/style\/style.css/..\/style\/print.css/g" $newname/index.html
  ##wkhtmltopdf --quiet --viewport-size 1280x1024 --disable-smart-shrinking $newname/index.html $newname/print.pdf
  #The following is ahack to replace names of stylesheets to their proper form.
  #Prior is only so that wkhtmltopdf will use the print.css instead of style.css
  sed -i "s/..\/style\/print.css/..\/style\/style.css/g" $newname/index.html
  sed -i "s/..\/style\/style.css media=/..\/style\/print.css media=/g" $newname/index.html
done
cd ..
#-------------------------------------------------------------------------------

echo "Done!"

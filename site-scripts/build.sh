#all commands are understood to be executed from root of site
#loop are executed from within a given directory and exited upon completion


#delete site-content directory, will be recreated when cloned
#delete contents of /contents
rm -rf site-content
rm -rf content
mkdir content
rm index.html

#pull down most current version of all site entries
git clone http://github.com/OKCody/Pages

#rename cloned directory to fit schema
mv Pages site-content

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
index=$(ls content/ | tail -n1)
cp content/$index index.html
#concatenate contents of head.html, $filename.html, and tail.html and write to
#file in archive directory
cat site-template/head.html index.html site-template/tail.html > index.html
sed -i "s/<title><\/title>/<title>Cody Taylor<\/title>/g ; s/.html<\/title>/<\/title>/g" index.html

cd content
for filename in *.html
do
  #remove dates from front of filenames in content/
  #from
  #yyyymmmdd_filename.html
  #to
  #filename.html
  #dates on filenames in site-content/ do not matter (not public facing)
  mv $filename ${filename:9}
done

for filename in *.html
do
  #find "<title></title>" in previously created file. replace with <title>$filename</title>
  #replace underscores with spaces and remove ".html" from end of filename
  sed -i "s/<title><\/title>/<title>${filename//_/ }<\/title>/g ; s/.html<\/title>/<\/title>/g" $filename
done
cd ..

#delete site-content directory, will be recreated when cloned
#delete contents of /contents
rm -rf site-content
rm content/*.html

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

  #find "<title></title>" in previously created file. replace with <title>$filename</title>
  #replace underscores with spaces and remove ".html" from end of filename
  sed -i "s/<title><\/title>/<title>${filename//_/ }<\/title>/g ; s/.html<\/title>/<\/title>/g" ../content/$filename
done

cd ../content

#create index.html from most recent file in /content based on date at front of filename
#yyyymmmddd_filename.html
#prepending date to filename in this way forces most recent page to bottom of ls
index=$(ls | tail -n1)
cp $index ../index.html

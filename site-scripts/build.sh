#delete site-content directory
rm -rf site-content

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

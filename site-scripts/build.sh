#delete site-content directory
rm -rf site-content
#pull down most current version of all site entries
git clone http://github.com/OKCody/Pages
#rename cloned directory to fit schema
mv Pages site-content
#concatenate contents of head.html, $filename.html, and tail.html and write to
#file in archive directory
cd site-content
for filename in *.html
do
  cat ../site-template/head.html $filename ../site-template/tail.html > ../content/$filename
done

rm *.html
cd site-content
for filename in *.html
do
python3 ../build.py $filename
done

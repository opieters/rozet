mkdir -p pictures

while read NAME
do
  wget -O "pictures/$NAME" "https://images.olivierpieters.be/public/mull-2016/$NAME"
    echo "$NAME"
done < image_list.txt


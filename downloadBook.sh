#!/bin/bash
echo "What is your auth id?"
read authId

echo "Which book do you want to download, provide an value such as: 1016937"
read bookId

rm -rf $bookId

# Create folder
mkdir $bookId

# download book
wget https://delivery-33.elib.se/ElibUReader/api/1.0/$authId/books/$bookId/content/0/10000?format=json -O $bookId/book.json

# extract html data
cat $bookId/book.json | jq .html > $bookId/book.html.json

# Remove \n from html
sed 's#\\n#<br>#g' $bookId/book.html.json > $bookId/book.html1

# Replace all \" with "
sed 's#\\"#"#g' $bookId/book.html1 > $bookId/book.html2

# replace all urls
sed -i 's/\/ElibUReader/https\:\/\/delivery-33.elib.se\/ElibUReader/g' $bookId/book.html2

#sed 's#\\# #g' $bookId/book.html.json > $bookId/book.html1


#tr '\\n' '\n' < $bookId/book.html.json > $bookId/book.html1

# Remove first and last character
cat $bookId/book.html2 | sed 's:^.\(.*\).$:\1:' > $bookId/book.html

# move to html
mv $bookId/book.html2 $bookId/book.html


# convert to epub
sleep 1
ebook-convert $bookId/book.html $bookId/book.epub

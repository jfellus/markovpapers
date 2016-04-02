#!/bin/bash


for i in `seq $1 $2`; do
echo $i
./paper.sh >/dev/null 2>/dev/null
mv paper.pdf ~/jumbo/users/link/jerofell/public_html/cpg/papers/$i.pdf 2>/dev/null
echo $i > ~/jumbo/users/link/jerofell/public_html/cpg/nb_papers.txt
done

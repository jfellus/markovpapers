#!/bin/bash
function author() {
	cat authors.txt | ./Debug/markov 20 3 | sed "s/ //g" | tr "[A-Z]" "[a-z]" | sed -e "s/\b\(.\)/\u\1/g" | sed "s/[^A-Za-z]/ /g" | sed "s/^ *//g" | awk '{print $1" "$2;}'
}


function conf() {
	randline conf.txt | sed "s/[^A-Za-z ]//g"
}

function where() {
	randline where.txt | sed "s/[#]//g"
}

function reftitle() {
	cat titles.txt | ./Debug/markov 50 1 | sed "s/%T/\n/g" | head -n 2 | tail -n 1
}

function title() {
	cat titles.txt | ./Debug/markov 100 1 | sed "s/%T/\n/g" | head -n 2 | tail -n 1
}

function abstract() {
	cat /run/shm/abstracts.txt | ./Debug/markov 200 2 | sed "s/\. /.\n/g" | tail -n +2 | head -n -1
}

function keywords() {
	for i in `seq 1 5`; do
		randline /home/jfellus/Bureau/hal/kw.txt
		echo ", "
	done
}

function paragraph() {
	cat /run/shm/abstracts.txt | ./Debug/markov $1 $2 | sed "s/\. /.\n/g" | tail -n +2 | head -n -1 | sed "s/[^A-Za-z0-9., éèà]//g" | sed "s/^. //g"
}

function caption() {
	cat /run/shm/abstracts.txt | ./Debug/markov 200 1 | sed "s/%T/\n/g" | tail -n +2 | sed "s/ /\n/g" | head -n 40 | tr "\n" " " | sed "s/%X//g"
}



cp abstracts.txt /run/shm/abstracts.txt





####################################

(

cat header.tex

echo '\title{'`title`'}'

echo "\author{"
for i in `seq 1 5`; do
	echo `author`, 
done
echo '\thanks{'This paper has been randomly generated to improve cross-disciplinary investigation in academic research, on `date "+%B %d, %Y"`'}'
echo '}'




echo '\IEEEtitleabstractindextext{'
	echo '\begin{abstract}'
	abstract 
	echo '\end{abstract}'
	echo '\begin{IEEEkeywords}'`keywords`'\end{IEEEkeywords}'
echo '}'



echo '\maketitle'
echo 
echo '\IEEEdisplaynontitleabstractindextext'
#echo
#echo '\IEEEpeerreviewmaketitle'

echo '\markboth{Proceedings of the 1st annual cross-disciplinary retreat of ETIS Lab, Vol.1, No.~1}'

echo '\IEEEraisesectionheading{\section{Introduction}\label{sec:introduction}}'
paragraph 500 2 | tr " " "\n" 



echo "\section{Related work}"
paragraph 800 2 | ./addcite.sh

echo "\section{Method}"


for i in `seq 1 3`; do
	IMG=/home/jfellus/Bureau/hal/method/img/`randline /home/jfellus/Bureau/hal/method/img.txt`
	paragraph 600 2
	echo "\begin{figure}"
	echo "\centering"
	echo "\includegraphics[width=\linewidth]{${IMG}}"
	echo "\caption{"`caption`"}"
	echo "\end{figure}"
done

echo "\section{Experimental results}"

for i in `seq 1 6`; do
	IMG=/home/jfellus/Bureau/hal/results/img/`randline /home/jfellus/Bureau/hal/results/img.txt`
	paragraph 300 2
	echo "\begin{figure}"
	echo "\centering"
	echo "\includegraphics[width=\linewidth]{${IMG}}"
	echo "\caption{"`caption`"}"
	echo "\end{figure}"
done



echo "\section{Discussion}"
paragraph 800 2

echo "\section{Conclusion}"
paragraph 300 2


cat footer.tex


for i in `seq 1 21`; do
echo '\bibitem{'a$i'}'
echo `author`", "`author`", "`author`", "
echo `reftitle`
echo "in "'\emph{'`conf`'}.'
echo `where`,
echo $((RANDOM%25 + 1990))"."
done

cat footer2.tex





) > paper.tex

pdflatex -interaction=nonstopmode paper.tex

#i=0
#while [ -f papers/$i.pdf ]; do i=$(( $i +1 )); done
#mkdir -p papers
#mv paper.pdf papers/$i.pdf

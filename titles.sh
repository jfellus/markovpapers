cat titles.txt | ./Debug/markov 100 1 | sed "s/%T/\n/g" | head -n 2 | tail -n 1

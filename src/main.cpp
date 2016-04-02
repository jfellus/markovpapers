/*
 * main.cpp
 *
 *  Created on: 1 févr. 2015
 *      Author: jfellus
 */

#include <string>
#include <list>
#include <vector>
#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <map>
#include <algorithm>

int MAX = 1;
int NB_WORDS=100;

std::vector<std::string> words;
std::map<std::string,std::vector<std::string>> markov;

std::string draw_next(const std::string& context) {
	if(context.empty()) {
		return words[rand()%words.size()];
	}
	std::string context2 = context;
	while(markov.count(context2)==0 && context2.find(' ')!=std::string::npos) {
		context2 = context2.substr(context2.find(' ')+1);
	}
	if(markov.count(context2)==0) {
		return words[rand()%words.size()];
	} else {
		return markov[context2][rand()%markov[context2].size()];
	}
}

void add(const std::string& context, const std::string& s){
//	std::cerr << "Add : (" << context << ") ->" << s << "\n";
	markov[context].push_back(s);
	std::string context2 = context;
	while(context2.find(' ')!=std::string::npos) {
		context2 = context2.substr(context2.find(' ')+1);
//		std::cerr << "Add : (" << context2 << ") ->" << s << "\n";
		markov[context2].push_back(s);
	}
}


std::string context,s;

int main(int argc, char **argv) {
	if(argc>=3) {
		NB_WORDS = atoi(argv[1]);
		MAX = atoi(argv[2]);
	}
	srand(clock());
	std::cerr << "Learn ... ";
	std::cerr.flush();

	while(std::cin.good()) {
		std::cin >> s;
		add(context, s);
		words.push_back(s);

		if(!context.empty()) context += " ";
		context += s;
		if(std::count(context.begin(), context.end(), ' ')>=MAX) {
			context = context.substr(context.find(' ')+1);
		}
	}

	std::cerr << " done\n";

	context = "";
	s = "";
	for(int i=0; i<NB_WORDS; i++) {
		s = draw_next(context);

		std::cout << s << " ";
		if(s[s.length()-1]=='.') {
			int zzz = rand()%5;
			if(zzz==0) std::cout << "\n\n";
		}


		if(!context.empty()) context += " ";
		context += s;
		if(std::count(context.begin(), context.end(), ' ')>=MAX) {
			context = context.substr(context.find(' ')+1);
		}
	}

	std::cout << "\n";
}

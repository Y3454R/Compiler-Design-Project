# Demo_compiler_project
This project was showed in 4th class of CSE3212. I redid the whole thing from scratch.
To run this:

Go to the location of the folder and type "cmd" on address bar. Then type these following command lines on the command prompt:

1. bison -d demo.y
2. flex demo.l
3. gcc lex.yy.c demo.tab.c -o exefile

Then run the "exefile"

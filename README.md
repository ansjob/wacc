wacc
====

While Analysis and Compile Chain - tools for analysing simple imperative algorithms

* While

While is a simple C-like imperative language that only has integer variables, and no such things as scopes or functions.
I guess it's a scripting language.

* WACC

This piece of software was developed as an exercise in Prolog.
It will lex, parse, compile, and run while-programs, and can also
perform analysis on them in terms of what safe assumptions can be made about variable assignments.

* Compiling

The only thing needed to compile the software is SWI-prolog.
Compiling is as simple as issuing the command ```make```.

* Running

Once the binaries are compiled, running a programs is as easy as doing ``` $ ./while file ``` 
where file is a path to a file containing a while program.
For examples of while-programs, see the programs-folder in this repo.

Running the analysis can be done similarly by running the ```wanalyze``` binary.
The ```wanalyze``` binary can take an optional argument which is the domain in which the program should execute.

For example ``` $./wanalyze oddeven programs/gcd.while```
will analyze the gcd program with the given parameters in the odd-even domain.

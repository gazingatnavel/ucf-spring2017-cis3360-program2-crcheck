# ucf-spring2017-cis3360-program2-crcheck
bash shell script for automated testing of crcheck program

This is a bash shell script that automates testing of the crcheck program for UCF Spring 2017 CIS 3360 program assignment 2.

The shell script (`run-test-cases.sh`) will work for a C source code file named crcheck.c or a Java source file named crcheck.java.

Here's what it does:

1. For C source, compiles the file `crcheck.c` to a `crcheck` executable. Prints a message if `crcheck.c` fails to compile. For Java source, compiles the file `crcheck.java` to `crcheck.class`.
2. Runs the `crcheck` executable with the `c` option for each plain data input file (e.g., `input2A.plain`) and with the `v` option for each crc data input file (e.g., `input2A.crc`), and writes the output to a file (e.g., `input2A-plain.txt` or `input2A-crc.txt`). Prints a message if the `crcheck` executable crashes or terminates before computing or verifying the input/crc file.
3. Compares the output file to the sample output file and prints either `PASS` or `fail (output does not match)`.


To use the shell script:

1. Copy the shell script and the sample output files from here to a directory in Eustis.
2. Copy the data input files provided for the assignment (`input2A.plain`, `input2A.crc`, etc.) to the same directory in Eustis.
3. Copy your `crcheck.c` (or `crcheck.java`) file to the same directory in Eustis.
4. Make the script executable by running the command `chmod 744 run-test-cases.sh`.
5. From within the directory where the files are located, run the command `./run-test-cases.sh`.

If everything works properly, you should see something like:

```
Compiling crcheck.c (or crcheck.java)...
Checking crcheck c WC-ngi.plain... PASS!
Checking crcheck v WC-ngi.crc... PASS!
Checking crcheck c input2A.plain... PASS!
Checking crcheck v input2A.crc... PASS!
Checking crcheck c WS.plain... PASS!
Checking crcheck v WS.crc... PASS!
Checking crcheck c WC-16.plain... PASS!
Checking crcheck v WC-16.crc... PASS!
Checking crcheck v WC-BOGUS.crc... PASS!
```


If your crcheck source fails to compile, you'll see:

```
fail (failed to compile)
```


If your program compiles, but crashes during execution or terminates before completing the computation, you'll see:

```
Checking crcheck c input2A.plain... fail (program failed or crashed)
```


If your program runs properly, but does not generate the same output as the sample output file, you'll see:

```
Checking crcheck c input2A.plain... fail (output does not match)
```

Some technical details:

1. The shell script uses the `diff` command to compare the output generated by your program to the sample output files.
2. The `-B` option is used with the `diff` command to ignore blank lines. This means that if your output has more or less blank lines than the sample output, the program will pass.

I've attempted to make the sample output files exactly match the output provided in the program assignment instructions. I'm not sure how closely the graders will expect the number of blank lines in your output to match those in the test output.

I'm not an expert in bash shell scripting, but this script seems to work for me in the Eustis linux environment. You may have to modify it slightly to work on your home computer. (Specifically, you may need to modify line 21 `gcc crcheck.c -o crcheck` to match the compiler on your home computer. On a Mac, you can use `cc crcheck.c -o crcheck`. Not sure what, if any, modifications would be required to run the script on a Windows computer.)

This script is closely modeled on similar testing scripts provided by Dr. Sean Szumlanski for COP 3503 Fall 2016 at UCF.

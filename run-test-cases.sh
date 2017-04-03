#!/bin/bash

# Variable '$?' is the exit status of a command

# Test for C or Java program.
if [ -a "crcheck.c" ]; then
    isC=1
elif [ -a "crcheck.java" ]; then
    isC=0
else 
    echo "Unable to find source file crcheck.c or crcheck.java"
    exit 1
fi

# Compile source into executable.
if [ $isC == 1 ]; then
    # Compile crcheck.c file to crcheck executable.
    echo "Compiling crcheck.c..."
    gcc crcheck.c -o crcheck 2> /dev/null
else
    # Compile crcheck.java file to crcheck.class executable.
    echo "Compiling crcheck.java"
    javac crcheck.java 2> /dev/null
fi

# Check that crcheck.c (or crcheck.java) compiled.
compile_val=$?
if [ $compile_val != 0 ]; then
    echo "fail (failed to compile)"
    exit 1
fi

FILES="WC-ngi
input2A
WS
WC-16"

# Loop through files.
for f in $FILES
do
	# Provide some feedback.
	echo -n "Checking crcheck c $f.plain... "
	
	# Run crcheck compute option
	if [ $isC == 1 ]; then
		./crcheck c $f.plain > $f-plain.txt 2> /dev/null
	else 
	    java crcheck c $f.plain > $f-plain.txt 2> /dev/null	
	fi
	
	execute_val=$?
	if [ $execute_val != 0 ]; then
		echo "fail (program failed or crashed)"
		exit 1
	fi

    # Compare the computed output file to the expected output file,
    # ignoring blank lines.
    diff -B $f-plain.txt $f-plain-output.txt > /dev/null

    # Print status, fail or pass.
    diff_val=$?
    if [ $diff_val != 0 ]; then
        echo "fail (output does not match)"
    else
        echo "PASS!"
    fi
    
    # Remove output file.
    rm $f-plain.txt

	# Provide some feedback.
	echo -n "Checking crcheck v $f.crc... "
	
	if [ $isC == 1 ]; then
		./crcheck v $f.crc > $f-crc.txt 2> /dev/null
	else
	    java crcheck v $f.crc > $f-crc.txt 2> /dev/null	
	fi

	execute_val=$?
	if [ $execute_val != 0 ]; then
		echo "fail (program failed or crashed)"
		exit 1
	fi

    # Compare the computed output file to the expected output file,
    # ignoring blank lines.
    diff -B $f-crc.txt $f-crc-output.txt > /dev/null

    # Print status, fail or pass.
    diff_val=$?
    if [ $diff_val != 0 ]; then
        echo "fail (output does not match)"
    else
        echo "PASS!"
    fi

    # Remove output file.
    rm $f-crc.txt
done

# Run for WS-BOGUS.crc, which fails CRC validation.
echo -n "Checking crcheck v WS-BOGUS.crc... "
./crcheck v WS-BOGUS.crc > WS-BOGUS-crc.txt 2> /dev/null

execute_val=$?
if [ $execute_val != 0 ]; then
	echo "fail (program failed or crashed)"
	exit 1
fi

# Compare the computed output file to the expected output file,
# ignoring blank lines.
diff -B WS-BOGUS-crc.txt WS-BOGUS-crc-output.txt > /dev/null

# Print status, fail or pass.
diff_val=$?
if [ $diff_val != 0 ]; then
	echo "fail (output does not match)"
else
	echo "PASS!"
fi

# Remove output file.
rm WS-BOGUS-crc.txt

exit 0



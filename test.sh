#!/bin/bash

# Set where your jcall bundle is installed
JCALL=/Users/chad/.vim/bundle/jcall.vim

#Where this test package is
JCALLTEST=/Users/chad/jcall_test
#JCALLTEST=$(basename $0)

method_check() {
    source_path=$1
    lineno=$2
    signature=$3

    output=$(/usr/bin/python $JCALL/py/method.py "$JCALLTEST$source_path" $lineno "$JCALLTEST/build"  "/tmp/jcall")
    if [ "$output" != "$signature" ]; then
        echo "method.py returned $output instead of $signature @ $source_path:$lineno"
    fi
}

jump_check() {
    source_path=$1
    lineno=$2
    method_name=$3
    expected_file=$4

    /usr/bin/python $JCALL/py/invoke.py "$JCALLTEST$source_path" $lineno "$method_name" "$JCALLTEST/build" "/tmp/jcall" > ${expected_file}.out

    diff -u ${expected_file}.out ${expected_file} > ${expected_file}.diff
    if [ "$?" -ne "0" ]; then
        echo "invoke.py returns different data for $source_path:$lineno $method_name"
        cat ${expected_file}.diff
        rm ${expected_file}.diff
    fi
}

call_check() {
    signature=$1
    expected_file=$2

    /usr/bin/python $JCALL/py/jcall.py "$JCALLTEST/build" "$signature" '/tmp/jcall' > ${expected_file}.out

    diff -u ${expected_file}.out ${expected_file} > ${expected_file}.diff
    if [ "$?" -ne "0" ]; then
        echo "jcall.py returns different data for $signature"
        cat ${expected_file}.diff
        rm ${expected_file}.diff
    fi
}

if [ "$1" == "-r" ]; then
    printf "\nRecompiling\n"
    ant compile
    printf "\nRefreshing Cache\n"
    vim +'norm ,ch' +qa! src/chad/Test.java
fi

printf "\nThis program will check the output of various calls.  If each section outputs nothing, then the plugin is working as expected.\n"

printf "\nChecking Methods\n"
method_check "/src/chad/A.java" 5 "chad.A.m1:()V"
method_check "/src/chad/B.java" 5 "chad.B.m2:()V"
method_check "/src/chad/C.java" 5 "chad.C.m1:()V"
method_check "/src/chad/C.java" 9 "chad.C.m3:()V"
method_check "/src/chad/I1.java" 4 "chad.I1.m1:()V"
method_check "/src/chad/I2.java" 4 "chad.I2.m2:()V"
method_check "/src/chad/I3.java" 4 "chad.I3.m3:()V"

printf "\nChecking Jumps\n"
jump_check "/src/chad/Test.java" 30 "test" test_jump/chad.Test.test
jump_check "/src/chad/Test.java" 32 "testm" test_jump/chad.Test.testm
jump_check "/src/chad/Test.java" 42 "doHi" test_jump/chad.Test.doHi
jump_check "/src/chad/Test.java" 13 "hi" test_jump/chad.Test.hi

printf "\nChecking Calls\n"
call_check "chad.test.doI3:(Lchad/I3;)V" test_call/chad.Test.doI3
call_check "chad.test.doC:(Lchad/C;)V" test_call/chad.Test.doC
call_check "chad.A.m1:()V" test_call/chad.A.m1
call_check "chad.B.m2:()V" test_call/chad.B.m2
call_check "chad.C.m1:()V" test_call/chad.C.m1
call_check "chad.C.m3:()V" test_call/chad.C.m3

# If you want to reset output as expected output
if [ "$2" == "-r" ]; then
    find test_jump -name \*.out | sed -e 's/\(.*\)\.out/\1/' | xargs -I {} mv {}.out {}
    find test_call -name \*.out | sed -e 's/\(.*\)\.out/\1/' | xargs -I {} mv {}.out {}
fi

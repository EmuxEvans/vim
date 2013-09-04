#!/bin/sh
# @file CppUTestPerform.sh
# @brief Generate performance reports
# @usage ./CppUTestPerform.sh
# @Example ./CppUTestPerform.sh
# @author emux, emuxevans@126.com
# @version 1.0.0
# @date 03/26/2013 00:44:21, 12th Tuesday
# @copyright Copyright (c) www.emuxevans.com 2011. All rights reserved.
# @reference
#
# @history
# -----------------------------------------------------------------------------
# @author emux, emuxevans@126.com
# @date 03/26/2013 00:44:21, 12th Tuesday
# @brief Create

uname|grep -i -q 'linux'
if [ $? -eq 0 ];then
  Os='linux'
  EchoOpt=-e
fi

mkdir -p tests/report/{,coverage,cppcheck,junit,leakcheck,lint,performance}

reportDir="tests/report"
testProg="tests/tests"
lintIncludeDir="-Iinclude/ -I/usr/local/include/"

if [ "x$Os" == "xlinux" ];then
  make clean && make CFLAGS="-fprofile-arcs -ftest-coverage -pg -g" CXXFLAGS="-fprofile-arcs -ftest-coverage -pg -g" LDFLAGS="-lgcov"
else
  #Rebuild the project with performce (gprof and gcov) flags
  cp config.status config.status.bck
  make clean && ./configure  CC=clang CXX=clang++ CFLAGS="-fprofile-arcs -ftest-coverage -pg -g" CXXFLAGS=$CFLAGS LDFLAGS=$ldflags && make
fi

#Generate performce report
perfDir="${reportDir}/performance"
perfLog="${perfDir}/performance.txt"
perfPng="${perfDir}/performance.png"
${testProg} && gprof ${testProg}  > ${perfLog}
gprof2dot.py -n0 -e0 ${perfLog}| dot -Tpng -o ${perfPng}

#Generate coverage report
gcovDir="${reportDir}/coverage"
gcovLog="${gcovDir}/coverage.txt"
lcov -t Coverage -d . -c -o ${gcovLog}
genhtml -o ${gcovDir} ${gcovLog}

#Generate memory leak report
leakDir="${reportDir}/leakcheck"
leakLog="${leakDir}/leakcheck.txt"
leakPng="${leakDir}/leakcheck.png"

if [ "x$Os" == "xlinux"];then
  cp config.status.bck config.status && ./config.status
fi
make clean && make && valgrind --log-file=${leakLog} --leak-check=full --show-reachable=yes --track-origins=yes ${testProg}
#which convert && cat ${leakLog} | convert label:@- ${leakPng}

#Generate callgrid report
callgridLog="${perfDir}/callgrid.txt"
callgridPng="${perfDir}/callgrid.png"
valgrind --tool=callgrind -v ${testProg} && mv callgrind* ${callgridLog}

#Generate test report with junit format 
cd ${reportDir}/junit && ../../tests -ojunit; which ant && ant -v; cd -

#Generate splint static analysis
lintDir="${reportDir}/lint"
lintLog="${lintDir}/splint.txt"
lintPng="${lintDir}/splint.png"
find -type f -name "*.[ch]" |xargs -t -I{} splint ${lintIncludeDir} {} > ${lintLog} 2>&1
#which convert && cat ${lintLog} | convert label:@- ${lintPng}

#Generate cppcheck report
cppcheckDir="${reportDir}/cppcheck"
cppcheckLog="${cppcheckDir}/cppcheck.xml"
echo $cppcheckDir
echo $cppcheckLog
cppcheck . -q --enable=all --error-exitcode=1 --std=c99 --std=posix --xml > $cppcheckLog 2>&1
cppcheck-htmlreport --source-dir=. --report-dir=$cppcheckDir --file=$cppcheckLog

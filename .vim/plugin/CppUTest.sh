#!/bin/sh
# @file initAutoTools.sh
# @brief Generate autotool files for the directory
# @usage ./initAutoTools.sh <clean|project name> [<bug report address>]
# @Example ./initAutoTools.sh demo  #Generate autotools files for project name 'demo'
#          ./initAutoTools.sh clean #Clean the generated files
# @author emux, emuxevans@126.com
# @version 1.0.0
# @date 03/26/2013 00:44:21, 12th Tuesday
# @copyright Copyright (c) www.emuxevans.com All rights reserved.
# @reference
#
# @history
# -----------------------------------------------------------------------------
# @author emux, emuxevans@126.com
# @date 03/26/2013 00:44:21, 12th Tuesday
# @brief Create

SRC_SUFIX="*.c,*.cpp"

uname|grep -i -q 'linux'
if [ $? -eq 0 ];then
  EchoOpt=-e
fi

#Check arguments
if [ $# -lt 2 ];then
  echo "Usage: $0 <clean|project name> [<bug report address>]"
  echo "Example: $0 demo your@email.com"
  exit 1
fi
if [ $# -eq 1 ];then
  bugReportAddress=your@email.com
else
  bugReportAddress=$2
fi

#Clean all generation file
if [ "x$1" == "xclean" ];then
  find -name 'Makefile.am'|xargs rm -fr
  find -name 'Makefile.in'|xargs rm -fr
  find -name 'Makefile'|xargs rm -fr
  rm -fr  README NEWS AUTHORS ChangeLog 
  rm -fr  autom4te.cache autoscan.log config.h.in configure configure.ac
  exit 0
fi

#Create a new project
project=$1
if [ -d $project ];then
  echo "Error: $project has exist"
  exit 1
fi

#Create the project directory
mkdir $project && cd $project
if [ $? -ne 0 ];then
  exit $?
fi

#Create base directories
mkdir -p include src mocks tests

#Create AllTests.cpp for TDD entry
allTestEntry=tests/AllTests.cpp
echo "#include \"CppUTest/CommandLineTestRunner.h\"" > $allTestEntry
echo "int main(int argc, char** argv)" >> $allTestEntry
echo "{" >> $allTestEntry
echo $EchoOpt "\treturn RUN_ALL_TESTS(argc, argv);" >> $allTestEntry
echo "}" >> $allTestEntry

#Create requirement files
touch README NEWS AUTHORS ChangeLog

#Create Makefile.am under all directories
for dir in `find -type d`
do
  am=$dir/Makefile.am
  touch $am

  #List all directory that contains sub-directory
  #Wanning: the name of parant directory and childrens' shoult NOT be the same
  #For example, 'path, path/path, path/path1', 'path/path' is not allow
  subdirs=""
  hasSubdir="no"
  for subdir in `find $dir -maxdepth 1 -type d|xargs -I{} basename {}`
  do
    if [ "x$subdir" != "x`basename $dir`" ];then
      subdirs="$subdirs $subdir"
      hasSubdir="yes"
      includedir="$includedir ${dir}/${subdir}"
    fi
  done

  #If the the directory has some sub-directories
  #We add the SUBDIRS to this Makefile.am and to .clang_complete file
  if [ $hasSubdir == "yes" ];then
    subdirs=`echo "$subdirs"|tr ' ' '\n'|sort|tr '\n' ' '`
    echo "SUBDIRS =$subdirs" >> $am
    echo "DIST_SUBDIRS = \$(SUBDIRS)" >> $am
    echo "$subdirs"|tr ' ' '\n'|grep -v '^$'|sed -e "s/^/-I/g" > .clang_complete
  fi
done


#Add the directories of header files and source files to Makefile.am
for dir in mocks tests src
do
  for am in `find $dir -name 'Makefile.am'`
  do
    dirname=`dirname $am`
    modulename=`basename $dirname | tr 'A-Z' 'a-z'`
    #if [ "x$dirname" != "x$dir" ];then
      sources=`ls $dirname|grep -e '\.c\(cpp\)*'|tr '\n' ' '`
      echo $EchoOpt "${modulename}_SOURCES = $sources \n" >> $am

      includedirs=`echo "$includedir"|sed 's#\.#\-I$(top_srcdir)#g'`
      echo $EchoOpt "INCLUDES =$includedirs \n" >> $am
    #fi
  done
done

#Create main.c
touch src/main.c

autoscan
mv configure.scan configure.ac

echo $EchoOpt "echo \\
\"------------------------------------------------------------------
\${PACKAGE_NAME} Version \${PACKAGE_VERSION}

Prefix: '\${prefix}'
Compiler: '\${CC} \${CFLAGS} \${CPPFLAGS}'

Package features:
	CFG_PATH: \${conf_dir}
	DEBUG: \${debug}

Now type 'make @<:@<target>@:>@'
	where the optional <target> is:
	all	--	build all binaries
	install	--	install everything
  check	--	do unit test for the code
  distcheck -- do unit test and distribute the package
-------------------------------------------------------------------\"" >> configure.ac

#Update project name, version and email
sed -i 's/FULL-PACKAGE-NAME/'"$project"'/' configure.ac
sed -i 's/\<VERSION\>/0.1/' configure.ac
sed -i 's/BUG-REPORT-ADDRESS/'"$bugReportAddress"'/' configure.ac

#Add 'AM_INIT_AUTOMAKE' after AC_INIT
sed -i '/AC_INIT/aAM_INIT_AUTOMAKE' configure.ac


#Add 'AC_PROG_RANLIB' after check for library
sed -i '/libraries/a\#AC_PROG_LIBTOOL' configure.ac
sed -i '/libraries/aAC_PROG_RANLIB' configure.ac

#Add compiler test, used for TDD in defferent platfrom
sed -i '/AC_PROG_LIBTOOL/aAM_CONDITIONAL(COMPILER_IS_COMPAQ_CC, [test x"$CXX" = xg++])' configure.ac

#Append platform testing for TDD in tests/Makefile.am file
testsMakefile=tests/Makefile.am
echo "LIBS = -lCppUTest -lCppUTestExt -lstdc++" >> $testsMakefile
echo "if COMPILER_IS_COMPAQ_CC" >> $testsMakefile
echo "TESTS = tests.sh" >> $testsMakefile
echo "else" >> $testsMakefile
echo "TESTS = tests.cross.sh" >> $testsMakefile
echo "endif" >> $testsMakefile
echo "EXTRA_DIST = tests.sh tests.cross.sh" >> $testsMakefile
sed -i '1inoinst_PROGRAMS=tests' $testsMakefile
sed -i '/tests_SOURCES/atests_LDADD=$(top_srcdir)/src/lib'"$project"'.a' $testsMakefile
touch tests/tests.sh

echo 'red="\033[1;37;41m"
green="\033[1;37;42m"
end="\033[0m"

test_result=$(./tests -v)
exit_code=$?
if [ $exit_code -ne 0 ];then
  color=$red
else
  color=$green
fi

tests=`echo "$test_result"|grep -v "OK\|Errors"`
result=`echo "$test_result"|grep "OK\|Errors"`
printf "$tests \n\n$color $result $end \n" 

exit $exit_code' > tests/tests.sh

chmod +x tests/tests.sh
cp tests/tests.sh tests/tests.cross.sh

#Append library name for src/Makefile.am
srcMakefile=src/Makefile.am
sed -i '1inoinst_LIBRARIES=lib'"$project"'.a' $srcMakefile
sed -i '2aEXTRA_DIST=lib'"$project"'.a' $srcMakefile
sed -i 's/src_\(SOURCES =\)/lib'"$project"'_a_\1 main.c/' $srcMakefile

#Append header file for include/Makefile.am
includeMakefile=include/Makefile.am
echo "EXTRA_DIST = " > $includeMakefile


#Generate Makefile.in
aclocal
autoheader
autoconf
automake --add-missing -a

#Generate Makefile
./configure

#Compile 
#make
make check -s
#make distcheck

#Check whether there has a test-driver file
#When would like to show the testing message
# "$@" >$log_file 2>&1
#we cat the $log_file
driverName=test-driver
if [ -e $driverName ];then
  sed -i '/estatus=$?/acat $log_file' $driverName
fi

#Create report directory
mkdir -p tests/report/{,performance,leakcheck,coverage,lint,junit}

#Create build.xml for generating html format test report by ant program
buildXml=tests/report/junit/build.xml
echo '<project>' > $buildXml
echo ' <junitreport>' >> $buildXml
echo '  <fileset dir=".">' >> $buildXml
echo '   <include name="cpputest*.xml" />' >> $buildXml
echo '  </fileset>' >> $buildXml
echo '  <report format="frames" todir="./html" />' >> $buildXml
echo ' </junitreport>' >> $buildXml
echo '</project>' >> $buildXml

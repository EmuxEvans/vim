" CppUTest.vim -- A plugin for CppUTest (A TDD testsuit) support.
" @Author:      emux (mailto:emuxevans@126.com)
" @Website:     www.emuxevans.com
" @License:     www.emuxevans.com 2013. All rights reserved.
" @Created:     03/29/2013 21:57:03, 12th Friday.
" @Revision:    0.1


if &cp || exists("loaded_CppUTest")
    finish
endif
let loaded_CppUTest = 1

let s:plugin_dir							= $HOME.'/.vim/'
let s:tddInitScript           = s:plugin_dir.'plugin/CppUTest.sh'
if !exists("g:myEmail ")
  let g:myEmail = "your@email.com"
endif

if !exists("g:CppUTestDefaultType ")
  let g:CppUTestDefaultType = "c"
endif

"
"Add a new TDD project
"
function! CppUTest_UnittestNew()
  "#1 Show msg "Create a new TDD Project: <project name>"
  "   get the input string as the path to project, save it to s:projectName
  let projectName = input('Create a new TDD Project: ')
  if projectName == ''
     echoerr "Please input the name of this TDD project."
     return
  endif
  
  "#2 Check if the projectName is exist
  " If exist
  "   Show msg "projectName has existen." and return
  let dirExist = finddir(projectName)
  if dirExist != ''
    echoerr dirExist." exists"
    return
  endif

  "#3 Check the tddInitScript
  " If not exist or unexecutable
  "   Show msg "Cannot execute tddInitScript" and return
  let tddInitScriptOk = executable(s:tddInitScript)
  if !tddInitScriptOk
    echoerr "Cannot execute initialization script: ".s:tddInitScript
    return
  endif
 
  "#4 Run tddInitScript to create the new project
  execute ':silent !'.s:tddInitScript.' '.projectName.' '.g:myEmail

  "#5 Change the work directory to the project
  execute ':lcd '.projectName
  
  "#6 Call CppUTest_UnittestAdd to add the first unittest
  if g:CppUTestDefaultType == 'c'
    let supportTypes = '[c]/cpp'
  elseif g:CppUTestDefaultType == 'cpp'
    let supportTypes = 'c/[cpp]'
  else
    echoerr "Error g:CppUTestDefaultType '".g:CppUTestDefaultType."'"
    return
  endif

  let type = input('Select a type for first TDD unittest '.supportTypes.': ')
  if type == ''
    let type = g:CppUTestDefaultType
  elseif type != 'c' && type != 'cpp'
    echoerr "Please type 'c' or 'cpp'"
    return
  endif
  call __CppUTest_UnittestAdd(type)
endfunction "CppUTest_UnittestNew

"
"Add a new TDD test file
"type = "c" or "cpp"
"
function! __CppUTest_UnittestAdd(type)
  "#1 Show msg "Create a new TDD unittest: <testname>"
  "   get the input string as the path to project, save it to s:projectName
  let testName = input('Create a new TDD unittest for '.a:type.': ')
  if testName == ''
    echoerr "Please input the name of the new TDD unittest."
    return
  endif

  let sourceFile = testName.'.'.a:type
  let sourceFilePath = "src/".sourceFile
  let sourceMakefile = "src/Makefile.am"

  let headerFile = testName.'.h'
  let headerFilePath = "include/".headerFile
  let headerMakefile = "include/Makefile.am"

  let testFile = testName.'Test.cpp'
  let testFilePath = "tests/".testFile
  let testMakefile = "tests/Makefile.am"

  "Test weather the test has existen
  let testExist = findfile(testFilePath)
  if testExist != ''
    echoerr "The test: ".testFilePath." exists"
    return
  endif

  "Prepend adding the file description automatically by c.vim
  let g:C_AutoInsertHeader = 0

  "Generate the test file and update the Makefile.am
  execute ":silent e ".testFilePath
  execute ':silent call C_InsertTemplate("comment.test'.a:type.'file-description")'
  execute ":silent w"

  "Generate the source file and update the Makefile.am
  execute ":silent new ".sourceFilePath
  execute ':silent call C_InsertTemplate("comment.srcfile-description")'
  execute ":silent wq"

  "Generate the header file and update the Makefile.am
  execute ":silent new ".headerFilePath
  execute ':silent call C_InsertTemplate("comment.srcfile-description-header")'
  execute ":silent wq"

  "Append these files to Makefile.am
  execute ":silent ! sed -i '/SOURCES/ s/$/ ".sourceFile."/' ".sourceMakefile
  execute ":silent ! sed -i '/SOURCES/ s/$/ ".testFile."/' ".testMakefile
  execute ":silent ! sed -i '/EXTRA_DIST/ s/$/ ".headerFile."/' ".headerMakefile

  "Restore the autocmd feature
  let g:C_AutoInsertHeader = 1

  "Redraw the screan to avoid urgly display
  execute ":silent redraw!"
endfunction "CppUTest_UnittestAdd

"
"Add a new TDD test file for c program
"
function! CppUTest_UnittestAdd()
  call __CppUTest_UnittestAdd("c")
endfunction "CppUTest_UnittestAdd

"
"Add a new TDD test file for cpp program
"
function! CppUTest_UnittestAddCpp()
  call __CppUTest_UnittestAdd("cpp")
endfunction "CppUTest_UnittestAdd


"
"Run unittests
"
function! CppUTest_UnittestRun()
  "Save all files"
  execute ":silent wa"

  "When we add new source file to Makefile.am, we may run 'automake.a'
  "to update Makefile.in
  execute ":silent ! make -s; if [ $? -ne 0 ];then automake -a && ./config.status; fi"

  "Run unittest
  execute "! make check -s"
endfunction "CppUTest_UnittestRun

"
"Generate performance reports
"
function! CppUTest_UnittestPerform()
  let reportDir = 'tests/report/'
  let testProg = 'tests/tests'
  let lintIncludeDir = '-Iinclude/ -I/usr/local/include/'

  "Rebuild the project with performce (gprof and gcov) flags
  execute ':silent !cp config.status config.status.bck'
  execute ':silent !make clean && which clang;if [ $? -eq 0 ];then CC=clang CXX=clang++;fi; ./configure CFLAGS="-fprofile-arcs -ftest-coverage -pg -g" CXXFLAGS=$CFLAGS && make'
  "execute ':silent !make clean && make CFLAGS="-fprofile-arcs -ftest-coverage -pg -g" CXXFLAGS="-fprofile-arcs -ftest-coverage -pg -g" LDFLAGS="-lgcov"'

  "Generate performce report
  let perfDir = reportDir.'/performance/'
  let perfLog = perfDir.'performance.txt'
  let perfPng = perfDir.'performance.png'
  execute ':silent !'.testProg.' && gprof '.testProg.' > '.perfLog
  execute ':silent !gprof2dot.py -n0 -e0 '.perfLog.'| dot -Tpng -o '.perfPng

  "Generate coverage report
  let gcovDir = reportDir.'coverage/'
  let gcovLog = gcovDir.'coverage.txt'
  execute ':silent !lcov -t Coverage -d . -c -o '.gcovLog
  execute ':silent !genhtml -o '.gcovDir.' '.gcovLog

  "Generate memory leak report
  let leakDir = reportDir.'leakcheck/'
  let leakLog = leakDir.'leakcheck.txt'
  let leakPng = leakDir.'leakcheck.png'

  execute ':silent !cp config.status.bck config.status && ./config.status'
  execute ':silent !make clean && make && valgrind --log-file='.leakLog.' --leak-check=full --show-reachable=yes --track-origins=yes '.testProg
  "execute ':silent !which convert && cat '.leakLog.'|convert label:@- '.leakPng

  "Generate callgrid report
  let callgridLog = perfDir.'callgrid.txt'
  let callgridPng = perfDir.'callgrid.png'
  execute ':silent !valgrind --tool=callgrind -v '.testProg.' && mv callgrind* '.callgridLog

  "Generate test report with junit format 
  execute ':silent !cd '.reportDir.'junit && ../../tests -ojunit; which ant && ant -v'

  "Generate splint static analysis
  let lintDir = reportDir.'lint/'
  let lintLog = lintDir.'splint.txt'
  let lintPng = lintDir.'splint.png'
  execute ':silent !find -type f -name "*.[ch]" |xargs -t -I{} splint '.lintIncludeDir.' {} > '.lintLog.' 2>&1'
  "execute ':silent !which convert && cat '.lintLog.'|convert label:@- '.lintPng

  "Redraw the screan to avoid urgly display
  execute ":silent redraw!"
endfunction

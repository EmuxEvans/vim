"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" by Amix - http://amix.dk/
"
" Maintainer: redguardtoo <chb_sh@hotmail.com>, Amir Salihefendic <amix3k at gmail.com>
" Version: 2.1
" Last Change: 21/03/08 23:00:01 
" fix some performance issue and syntax bugs
" Last Change: 12/08/06 13:39:28
" Fixed (win32 compatible) by: redguardtoo <chb_sh at gmail.com>
" This vimrc file is tested on platforms like win32,linux, cygwin,mingw
" and vim7.0, vim6.4, vim6.1, vim5.8.9 by redguardtoo
"
"
" Tip:
" If you find anything that you can't understand than do this:
" help keyword OR helpgrep keyword
" Example:
" Go into command-line mode and type helpgrep nocompatible, ie.
" :helpgrep nocompatible
" then press <leader>c to see the results, or :botright cw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" turn off nice effect on status bar title
let performance_mode=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode..

set nocompatible

if &term =~ '^\(xterm\|screen\)$' 
	set t_Co=256
endif

function! MySys()
	if has("win32")
		return "win32"
	elseif has("unix")
		return "unix"
	else
		return "mac"
	endif
endfunction
"Set shell to be bash
if MySys() == "unix" || MySys() == "mac"
	set shell=bash
else
	"I have to run win32 python without cygwin
	"set shell=E:cygwininsh
endif

"Sets how many lines of history VIM har to remember
set history=400

"Enable filetype plugin
filetype on
if has("eval") && v:version>=600
	filetype plugin on
	filetype indent on
endif

"Set to auto read when a file is changed from the outside
if exists("&autoread")
	set autoread
endif

"Have the mouse enabled all the time:
if exists("&mouse")
	set mouse=a "Cause the mouse cannot copy on right click
endif

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast saving
nmap <leader>x :xa!<cr>
nmap <leader>w :w!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Font
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax hl
if MySys()=="unix"
	if v:version<600
		if filereadable(expand("$VIM/syntax/syntax.vim"))
			syntax on
		endif
	else
		syntax on
	endif
else
	syntax on
endif

"internationalization
"I only work in Win2k Chinese version
if has("multi_byte")
	"set bomb 
  set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,latin1 
  " CJK environment detection and corresponding setting 
  if v:lang =~ "^zh_CN" 
    " Use cp936 to support GBK, euc-cn == gb2312 
    set encoding=cp936 
    set termencoding=cp936 
    set fileencoding=cp936 
  elseif v:lang =~ "^zh_TW" 
    " cp950, big5 or euc-tw 
    " Are they equal to each other? 
    set encoding=big5 
    set termencoding=big5 
    set fileencoding=big5 
  elseif v:lang =~ "^ko" 
    " Copied from someone's dotfile, untested 
    set encoding=euc-kr 
    set termencoding=euc-kr 
    set fileencoding=euc-kr 
  elseif v:lang =~ "^ja_JP" 
    " Copied from someone's dotfile, untested 
    set encoding=euc-jp 
    set termencoding=euc-jp 
    set fileencoding=euc-jp 
  endif 
  " Detect UTF-8 locale, and replace CJK setting if needed 
  if v:lang =~ "utf8$" || v:lang =~ "UTF-8$" 
    set encoding=utf-8 
    set termencoding=utf-8 
    set fileencoding=utf-8 
  endif
endif

"if you use vim in tty,
"'uxterm -cjk' or putty with option 'Treat CJK ambiguous characters as wide' on
if exists("&ambiwidth")
	set ambiwidth=double
endif

if has("gui_running")
	set guioptions-=m
	set guioptions-=T
	set guioptions-=l
	set guioptions-=L
	set guioptions-=r
	set guioptions-=R

	if MySys()=="win32"
		"start gvim maximized
		if has("autocmd")
			au GUIEnter * simalt ~x
		endif
	endif
	"let psc_style='cool'
	if v:version > 601 
		colorscheme molokai
	endif
else
	if v:version > 601 
		colorscheme molokai
	endif
endif

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=cheetah<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=python<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>

"Highlight current
if has("gui_running")
	if exists("&cursorline")
		set cursorline
	endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fileformat
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetype
set ffs=unix,dos,mac

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
set so=7

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
set hid

"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
"set ignorecase
set incsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"show matching bracet
set showmatch

"How many tenths of a second to blink
set mat=8

"Highlight search thing
set hlsearch

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
"Format the statusline
" Nice statusbar
if performance_mode
else
	set laststatus=2
	set statusline=
	set statusline+=%2*%-3.3n%0*\ " buffer number
	set statusline+=%f\ " file name
	set statusline+=%h%1*%m%r%w%0* " flags
	set statusline+=[
	if v:version >= 600
		set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
		set statusline+=%{&encoding}, " encoding
	endif
	set statusline+=%{&fileformat}] " file format
	if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
		set statusline+=\ %{VimBuddy()} " vim buddy
	endif
	set statusline+=%= " right align
	set statusline+=%2*0x%-8B\ " current char
	set statusline+=%-14.(%l,%c%V%)\ %<%P " offset

	" special statusbar for special windows
	if has("autocmd")
		au FileType qf
					\ if &buftype == "quickfix" |
					\ setlocal statusline=%2*%-3.3n%0* |
					\ setlocal statusline+=\ \[Compiler\ Messages\] |
					\ setlocal statusline+=%=%2*\ %<%P |
					\ endif

		fun! FixMiniBufExplorerTitle()
			if "-MiniBufExplorer-" == bufname("%")
				setlocal statusline=%2*%-3.3n%0*
				setlocal statusline+=\[Buffers\]
				setlocal statusline+=%=%2*\ %<%P
			endif
		endfun

		if v:version>=600
			au BufWinEnter *
						\ let oldwinnr=winnr() |
						\ windo call FixMiniBufExplorerTitle() |
						\ exec oldwinnr . " wincmd w"
		endif
	endif

	" Nice window title
	if has('title') && (has('gui_running') || &title)
		set titlestring=
		set titlestring+=%f\ " file name
		set titlestring+=%h%m%r%w " flags
		set titlestring+=\ -\ %{v:progname} " program name
	endif
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around and tab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Map space to / and c-space to ?
map <space> /

"Smart way to move btw. window
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l



"Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

if v:version>=700
	set switchbuf=usetab
endif

if exists("&showtabline")
	set stal=2
endif

"Moving fast to front, back and 2 sides ;)
imap <m-$> <esc>$a
imap <m-0> <esc>0i
imap <D-$> <esc>$a
imap <D-0> <esc>0i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Autocommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Switch to current dir
map <leader>cd :cd %:p:h<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
")
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $w <esc>`>a"<esc>`<i"<esc>

"Map auto complete of (, ", ', [
"http://www.vim.org/tips/tip.php?tip_id=153
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrev
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Comment for C like language
if has("autocmd")
	au BufNewFile,BufRead *.js,*.htc,*.c,*.tmpl,*.css ino $c /**<cr> **/<esc>O
endif

"My information
ia xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
"iab xname Amir Salihefendic

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line of text using control
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if MySys() == "mac"
	nmap <D-j> <M-j>
	nmap <D-k> <M-k>
	vmap <D-j> <M-j>
	vmap <D-k> <M-k>
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command-line config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! Cwd()
	let cwd = getcwd()
	return "e " . cwd
endfunc

func! DeleteTillSlash()
	let g:cmd = getcmdline()
	if MySys() == "unix" || MySys() == "mac"
		let g:cmd_edited = substitute(g:cmd, "(.*[/]).*", "", "")
	else
		let g:cmd_edited = substitute(g:cmd, "(.*[\]).*", "", "")
	endif
	if g:cmd == g:cmd_edited
		if MySys() == "unix" || MySys() == "mac"
			let g:cmd_edited = substitute(g:cmd, "(.*[/]).*/", "", "")
		else
			let g:cmd_edited = substitute(g:cmd, "(.*[\]).*[\]", "", "")
		endif
	endif
	return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
	return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"cno $q <C->eDeleteTillSlash()<cr>
"cno $c e <C->eCurrentFileDir("e")<cr>
"cno $tc <C->eCurrentFileDir("tabnew")<cr>
cno $th tabnew ~/
cno $td tabnew ~/Desktop/

"Bash like
cno <C-A> <Home>
cno <C-E> <End>
cno <C-K> <C-U>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffer realted
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Fast open a buffer by search for a name
"map <c-q> :sb

"Open a dummy buffer for paste
map <leader>q :e ~/buffer<cr>

"Restore cursor to file position in previous editing session
set viminfo='10,"100,:20,%,n~/.viminfo

" Buffer - reverse everything ... :)
map <F9> ggVGg?

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobackup
set nowb
"set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
if exists("&foldenable")
	set fen
endif

if exists("&foldlevel")
	set fdl=0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text option
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" python script
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set backspace=2
set smarttab
set lbr
"set tw=500

""""""""""""""""""""""""""""""
" => Indent
""""""""""""""""""""""""""""""
"Auto indent
set ai

"Smart indet
set si

"C-style indenting
if has("cindent")
	set cindent
endif

"Wrap line
set wrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>sn ]
map <leader>sp [
map <leader>sa zg
map <leader>s? z=



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Yank Ring
""""""""""""""""""""""""""""""
map <leader>y :YRShow<cr>

""""""""""""""""""""""""""""""
" => File explorer
""""""""""""""""""""""""""""""
"Split vertically
let g:explVertical=1

"Window size
let g:explWinSize=35

let g:explSplitLeft=1
let g:explSplitBelow=1

"Hide some file
let g:explHideFiles='^.,.*.class$,.*.swp$,.*.pyc$,.*.swo$,.DS_Store$'

"Hide the help thing..
let g:explDetailedHelp=0


""""""""""""""""""""""""""""""
" => Minibuffer
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 0
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1

"WindowZ
map <c-w><c-t> :WMToggle<cr>
let g:bufExplorerSortBy = "name"

""""""""""""""""""""""""""""""
" => LaTeX Suite thing
""""""""""""""""""""""""""""""
"set grepprg=grep -r -s -n
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_ViewRule_pdf='xpdf'

if has("autocmd")
	"Binding
	au BufRead *.tex map <silent><leader><space> :w!<cr> :silent! call Tex_RunLaTeX()<cr>

	"Auto complete some things ;)
	au BufRead *.tex ino <buffer> $i indent
	au BufRead *.tex ino <buffer> $* cdot
	au BufRead *.tex ino <buffer> $i item
	au BufRead *.tex ino <buffer> $m [<cr>]<esc>O
endif

""""""""""""""""""""""""""""""
" => Tag list (ctags) - not used
""""""""""""""""""""""""""""""
"let Tlist_Ctags_Cmd = "/sw/bin/ctags-exuberant"
"let Tlist_Sort_Type = "name"
"let Tlist_Show_Menu = 1
"map <leader>t :Tlist<cr>
map <F3> :Tlist<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Todo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au BufNewFile,BufRead *.todo so ~/vim_local/syntax/amido.vim

""""""""""""""""""""""""""""""
" => VIM
""""""""""""""""""""""""""""""
if has("autocmd") && v:version>600
	au BufRead,BufNew *.vim map <buffer> <leader><space> :w!<cr>:source %<cr>
endif

""""""""""""""""""""""""""""""
" => HTML related
""""""""""""""""""""""""""""""
" HTML entities - used by xml edit plugin
let xml_use_xhtml = 1
"let xml_no_auto_nesting = 1

"To HTML
let html_use_css = 0
let html_number_lines = 0
let use_xhtml = 1


""""""""""""""""""""""""""""""
" => Ruby & PHP section
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
""Run the current buffer in python - ie. on leader+space
"au BufNewFile,BufRead *.py so ~/vim_local/syntax/python.vim
"au BufNewFile,BufRead *.py map <buffer> <leader><space> :w!<cr>:!python %<cr>
"au BufNewFile,BufRead *.py so ~/vim_local/plugin/python_fold.vim

""Set some bindings up for 'compile' of python
"au BufNewFile,BufRead *.py set makeprg=python -c "import py_compile,sys; sys.stderr=sys.stdout; py_compile.compile(r'%')"
"au BufNewFile,BufRead *.py set efm=%C %.%#,%A File "%f", line %l%.%#,%Z%[%^ ]%@=%m
"au BufNewFile,BufRead *.py nmap <buffer> <F8> :w!<cr>:make<cr>

""Python iMap
"au BufNewFile,BufRead *.py set cindent
"au BufNewFile,BufRead *.py ino <buffer> $r return
"au BufNewFile,BufRead *.py ino <buffer> $s self
"au BufNewFile,BufRead *.py ino <buffer> $c ##<cr>#<space><cr>#<esc>kla
"au BufNewFile,BufRead *.py ino <buffer> $i import
"au BufNewFile,BufRead *.py ino <buffer> $p print
"au BufNewFile,BufRead *.py ino <buffer> $d """<cr>"""<esc>O

""Run in the Python interpreter
"function! Python_Eval_VSplit() range
" let src = tempname()
" let dst = tempname()
" execute ": " . a:firstline . "," . a:lastline . "w " . src
" execute ":!python " . src . " > " . dst
" execute ":pedit! " . dst
"endfunction
"au BufNewFile,BufRead *.py vmap <F7> :call Python_Eval_VSplit()<cr>


""""""""""""""""""""""""""""""
" => Cheetah section
"""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""
" => Java section
"""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
"au BufNewFile,BufRead *.js so ~/vim_local/syntax/javascript.vim
"function! JavaScriptFold()
" set foldmethod=marker
" set foldmarker={,}
" set foldtext=getline(v:foldstart)
"endfunction
"au BufNewFile,BufRead *.js call JavaScriptFold()
"au BufNewFile,BufRead *.js imap <c-t> console.log();<esc>hi
"au BufNewFile,BufRead *.js imap <c-a> alert();<esc>hi
"au BufNewFile,BufRead *.js set nocindent
"au BufNewFile,BufRead *.js ino <buffer> $r return

"au BufNewFile,BufRead *.js ino <buffer> $d //<cr>//<cr>//<esc>ka<space>
"au BufNewFile,BufRead *.js ino <buffer> $c /**<cr><space><cr>**/<esc>ka


if has("eval") && has("autocmd")
	"vim 5.8.9 on mingw donot know what is <SID>, so I avoid to use function
	"c/cpp
	fun! Abbrev_cpp()
		ia <buffer> cci const_iterator
		ia <buffer> ccl cla
		ia <buffer> cco const
		ia <buffer> cdb bug
		ia <buffer> cde throw
		ia <buffer> cdf /** file<CR><CR>/<Up>
		ia <buffer> cdg ingroup
		ia <buffer> cdn /** Namespace <namespace<CR><CR>/<Up>
		ia <buffer> cdp param
		ia <buffer> cdt test
		ia <buffer> cdx /**<CR><CR>/<Up>
		ia <buffer> cit iterator
		ia <buffer> cns Namespace ianamespace
		ia <buffer> cpr protected
		ia <buffer> cpu public
		ia <buffer> cpv private
		ia <buffer> csl std::list
		ia <buffer> csm std::map
		ia <buffer> css std::string
		ia <buffer> csv std::vector
		ia <buffer> cty typedef
		ia <buffer> cun using Namespace ianamespace
		ia <buffer> cvi virtual
		ia <buffer> #i #include
		ia <buffer> #d #define
	endfunction

	fun! Abbrev_java()
		ia <buffer> #i import
		ia <buffer> #p System.out.println
		ia <buffer> #m public static void main(String[] args)
	endfunction

	fun! Abbrev_python()
		ia <buffer> #i import
		ia <buffer> #p print
		ia <buffer> #m if __name__=="__main__":
	endfunction

	fun! Abbrev_aspvbs()
		ia <buffer> #r Response.Write
		ia <buffer> #q Request.QueryString
		ia <buffer> #f Request.Form
	endfunction

	fun! Abbrev_js()
		ia <buffer> #a if(!0){throw Error(callStackInfo());}
	endfunction

	augroup abbreviation
		au!
		au FileType javascript :call Abbrev_js()
		au FileType cpp,c :call Abbrev_cpp()
		au FileType java :call Abbrev_java()
		au FileType python :call Abbrev_python()
		au FileType aspvbs :call Abbrev_aspvbs()
	augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remove the Windows ^M
noremap <leader>m :%s/\r//g<CR>

"Paste toggle - when pasting something in, don't indent.
"set pastetoggle=<F3>

"Remove indenting on empty line
map <F2> :%s/s*$//g<cr>:noh<cr>''

"Super paste
ino <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

"clipboard with xclip
if MySys() == "unix" 
	vmap <F6> :!xclip -sel c<CR>
	map <F7> :-1r!xclip -o -seln c<CR>'z
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" doxygen setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:DoxygenToolkit_authorName="emux, emuxevans@126.com"
let s:licenseTag="Copyright(C)\<enter>"
let s:licenseTag=s:licenseTag."For free\<enter>"
let s:licenseTag=s:licenseTag."All right reserved\<enter>"
let g:DoxygenToolkit_licenseTag=s:licenseTag

let s:tagPost="`<specify>`"
let g:DoxygenToolkit_briefTag_post=""
let g:DoxygenToolkit_templateParamTag_post=s:tagPost
let g:DoxygenToolkit_paramTag_post = " [in] ".s:tagPost
let g:DoxygenToolkit_throwTag_post=s:tagPost

let g:DoxygenToolkit_briefTag_funcName="yes"
"let g:doxygen_enhanced_color=1
let g:DoxygenToolkit_blockHeader=""
let g:DoxygenToolkit_blockFooter=""
let g:DoxygenToolkit_returnTag = "@return -1 -- failure \\n 0 -- success"

function EmuxDoxygenDoc()
	if !exists("g:DoxygenDoc_name")
		let g:EmuxDoxygenDoc_name = input ("Project name: ")
	endif

	if !exists("g:DoxygenDoc_number")
		let g:EmuxDoxygenDoc_number = input ("Project number: ")
	endif

	let g:Doxyfile_name = "~/.vim/doxygen/Doxyfile"
	let g:Doxytab_img = "~/.vim/doxygen/image/*.png"
	execute ":silent !mkdir -p doc"
	execute ":silent !sed -i.bck 's/PROJECTNAME/" . g:EmuxDoxygenDoc_name . "/g' " . g:Doxyfile_name
	execute ":silent !sed -i 's/PROJECTNUMBER/" . g:EmuxDoxygenDoc_number . "/g' " . g:Doxyfile_name
	execute ":!doxygen " . g:Doxyfile_name
	execute ":!cp " . g:Doxytab_img . " doc/html"
	execute ":silent !mv " . g:Doxyfile_name . ".bck " . g:Doxyfile_name
endfunction
imap <C-g><C-j> <Esc>:Dox <CR>
nmap <C-g><C-j> :Dox <CR>
map <C-g><C-d> :call EmuxDoxygenDoc() <CR>
map <leader>gd :call EmuxDoxygenDoc() <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
set csprg=/usr/bin/cscope
set csto=1
set cst
set nocsverb
" add any database in current directory
if filereadable("cscope.out")
cs add cscope.out
endif
set csverb
endif

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR> 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gtags setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Find definition of current symbol using Gtags
map <C-?> <esc>:Gtags -r <CR>

"Find references to current symbol using Gtags
"map <S-F> <esc>:Gtags <CR>

"Go to previous file
map <C-p> <esc>:bp <CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" generate ctags, gtags and cscope for c
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nmap <C-F12> :!ctags -R --c-kinds=+p --fields=+iaS --extra=+q && gtags && cscope -Rbq <CR>
"nmap <C-F12> :!ctags -R --c-kinds=+px --fields=+iaS --extra=+q && gtags && cscope -Rbq <CR>
"nmap <C-F12> :!ctags -R --sort=foldcase --c-kinds=+px --fields=+iaS --extra=+q && gtags && cscope -Rbq <CR>
"nmap <C-F12> :!ctags -R --sort=foldcase --fields=+iaS --extra=+q && gtags && cscope -Rbq <CR>
nmap <C-F12> :!ctags -R --sort=foldcase --fields=+iaS --extra=+q<CR>
nmap <leader>gt :!ctags -R --sort=foldcase --fields=+iaS --extra=+q<CR>
set tags+=~/.vim/tags/systags
set tags+=~/.vim/tags/localtags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" source explorer setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" // Set the height of Source Explorer window 
let g:SrcExpl_winHeight = 8 

" // Set 100 ms for refreshing the Source Explorer 
let g:SrcExpl_refreshTime = 100 

" // Set "Enter" key to jump into the exact definition context 
let g:SrcExpl_jumpKey = "<ENTER>" 

" // Set "Space" key for back from the definition context 
let g:SrcExpl_gobackKey = "<SPACE>" 

" // In order to Avoid conflicts, the Source Explorer should know what plugins 
" // are using buffers. And you need add their bufname into the list below 
" // according to the command ":buffers!" 
 let g:SrcExpl_pluginList = [ 
        \ "__Tag_List__", 
        \ "_NERD_tree_", 
        \ "Source_Explorer" 
    \ ] 

" // Enable/Disable the local definition searching, and note that this is not 
" // guaranteed to work, the Source Explorer doesn't check the syntax for now. 
" // It only searches for a match with the keyword according to command 'gd' 
let g:SrcExpl_searchLocalDef = 1

" // Do not let the Source Explorer update the tags file when opening 
let g:SrcExpl_isUpdateTags = 0 

" // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to 
" //  create/update a tags file 
"let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ." 

" // Set "<F12>" key for updating the tags file artificially 
let g:SrcExpl_updateTagsKey = "<F12>" 



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trinity setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Open and close all the three plugins [srcexpl, taglist, NERD_tree]on the same time
nmap <C-F5> :TrinityToggleAll<CR>
nmap <leader>ta :TrinityToggleAll<CR>

"Open and close the srcxpl.vim separately"
nmap <C-F6> :TrinityToggleSourceExplorer<CR>
nmap <leader>ts :TrinityToggleSourceExplorer<CR>

"Open and close the taglist.vim separately"
nmap <C-F7> :TrinityToggleTagList<CR>
nmap <leader>tl :TrinityToggleTagList<CR>

"Open and close the NERD_tree.vim separately"
nmap <C-F8> :TrinityToggleNERDTree<CR>
nmap <leader>tt :TrinityToggleNERDTree<CR>


"Window jumps
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" jad setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augr class
au!
au bufreadpost,filereadpost *.class %!jad -noctor -ff -i -p %
au bufreadpost,filereadpost *.class set readonly
au bufreadpost,filereadpost *.class set ft=java
au bufreadpost,filereadpost *.class normal gg=G
au bufreadpost,filereadpost *.class set nomodified
au bufreadpost,filereadpost *.class set nomodifiable
augr END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" restart setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" latex setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set grepprg=grep\ -nH\ $*
set shellslash
let g:tex_flavor='latex'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sketch setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-F11> :call ToggleSketch()<CR>

"Avoid to pressing ENTERY key
"set noshowcmd


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" manpageview setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:manpageview_winopen= "hsplit="
"		:[count]HMan topic    -- g:manpageview_winopen= "hsplit"
"		:[count]HEMan topic    -- g:manpageview_winopen= "hsplit="
"		:[count]VMan topic     -- g:manpageview_winopen= "vsplit"
"		:[count]VEMan topic    -- g:manpageview_winopen= "vsplit="
"		:[count]OMan topic     -- g:manpageview_winopen= "osplit"
"		:[count]RMan topic     -- g:manpageview_winopen= "reuse"



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" c.vim csupport setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:C_FormatDate            = '%m/%d/%Y'
let g:C_FormatTime            = '%T, %Wth %A'
let g:C_FormatYear            = '%Y'
let g:C_Ctrl_j								= "off"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TOhtml setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:html_use_css = 1
let g:use_xhtml = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zencodin.vim setting for html edit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:use_zen_complete_tag = 1
let g:user_zen_leader_key = '<c-y>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fuzzfinder Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"
" FuzzyFinder Configure"{{{
"
"let g:fuf_modesDisable = [ 'mrufile', 'mrucmd', ]
let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> sj     :FufBuffer<CR>
nnoremap <silent> sk     :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> sK     :FufFileWithFullCwd<CR>
nnoremap <silent> s<C-k> :FufFile<CR>
nnoremap <silent> sl     :FufCoverageFileChange<CR>
nnoremap <silent> sL     :FufCoverageFileChange<CR>
nnoremap <silent> s<C-l> :FufCoverageFileRegister<CR>
nnoremap <silent> sd     :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> sD     :FufDirWithFullCwd<CR>
nnoremap <silent> s<C-d> :FufDir<CR>
nnoremap <silent> sn     :FufMruFile<CR>
nnoremap <silent> sN     :FufMruFileInCwd<CR>
nnoremap <silent> sm     :FufMruCmd<CR>
nnoremap <silent> su     :FufBookmarkFile<CR>
nnoremap <silent> s<C-u> :FufBookmarkFileAdd<CR>
vnoremap <silent> s<C-u> :FufBookmarkFileAddAsSelectedText<CR>
nnoremap <silent> si     :FufBookmarkDir<CR>
nnoremap <silent> s<C-i> :FufBookmarkDirAdd<CR>
nnoremap <silent> st     :FufTag<CR>
nnoremap <silent> sT     :FufTag!<CR>
nnoremap <silent> s<C-]> :FufTagWithCursorWord!<CR>
nnoremap <silent> s,     :FufBufferTag<CR>
nnoremap <silent> s<     :FufBufferTag!<CR>
vnoremap <silent> s,     :FufBufferTagWithSelectedText!<CR>
vnoremap <silent> s<     :FufBufferTagWithSelectedText<CR>
nnoremap <silent> s}     :FufBufferTagWithCursorWord!<CR>
nnoremap <silent> s.     :FufBufferTagAll<CR>
nnoremap <silent> s>     :FufBufferTagAll!<CR>
vnoremap <silent> s.     :FufBufferTagAllWithSelectedText!<CR>
vnoremap <silent> s>     :FufBufferTagAllWithSelectedText<CR>
nnoremap <silent> s]     :FufBufferTagAllWithCursorWord!<CR>
nnoremap <silent> sg     :FufTaggedFile<CR>
nnoremap <silent> sG     :FufTaggedFile!<CR>
nnoremap <silent> so     :FufJumpList<CR>
nnoremap <silent> sp     :FufChangeList<CR>
nnoremap <silent> sq     :FufQuickfix<CR>
nnoremap <silent> sy     :FufLine<CR>
nnoremap <silent> sh     :FufHelp<CR>
nnoremap <silent> se     :FufEditDataFile<CR>
nnoremap <silent> sr     :FufRenewCache<CR>
"
" F2 and shift+F2 to call FuzzyFinder menu""{{{
"
function! GetAllCommands()
 redir => commands
 silent command
 redir END
 return map((split(commands, "\n")[3:]),
		 \      '":" . matchstr(v:val, ''^....\zs\S*'')')
endfunction

" Custom command list
let g:fuf_com_list=[':exe "FufBuffer                       " |" sb     ',
									\':exe "FufFileWithCurrentBufferDir     " |" sk     ',
									\':exe "FufFileWithFullCwd              " |" sK     ',
									\':exe "FufFile                         " |" s<C-k> ',
									\':exe "FufCoverageFileChange           " |" sl     ',
									\':exe "FufCoverageFileChange           " |" sL     ',
									\':exe "FufCoverageFileRegister         " |" s<C-l> ',
									\':exe "FufDirWithCurrentBufferDir      " |" sd     ',
									\':exe "FufDirWithFullCwd               " |" sD     ',
									\':exe "FufDir                          " |" s<C-d> ',
									\':exe "FufMruFile                      " |" sn     ',
									\':exe "FufMruFileInCwd                 " |" sN     ',
									\':exe "FufMruCmd                       " |" sm     ',
									\':exe "FufBookmarkFile                 " |" su     ',
									\':exe "FufBookmarkFileAdd              " |" s<C-u> ',
									\':exe "FufBookmarkFileAddAsSelectedText" |" s<C-u> ',
									\':exe "FufBookmarkDir                  " |" si     ',
									\':exe "FufBookmarkDirAdd               " |" s<C-i> ',
									\':exe "FufTag                          " |" st     ',
									\':exe "FufTag!                         " |" sT     ',
									\':exe "FufTagWithCursorWord!           " |" s<C-]> ',
									\':exe "FufBufferTag                    " |" s,     ',
									\':exe "FufBufferTag!                   " |" s<     ',
									\':exe "FufBufferTagWithSelectedText!   " |" s,     ',
									\':exe "FufBufferTagWithSelectedText    " |" s<     ',
									\':exe "FufBufferTagWithCursorWord!     " |" s}     ',
									\':exe "FufBufferTagAll                 " |" s.     ',
									\':exe "FufBufferTagAll!                " |" s>     ',
									\':exe "FufBufferTagAllWithSelectedText!" |" s.     ',
									\':exe "FufBufferTagAllWithSelectedText " |" s>     ',
									\':exe "FufBufferTagAllWithCursorWord!  " |" s]     ',
									\':exe "FufTaggedFile                   " |" sg     ',
									\':exe "FufTaggedFile!                  " |" sG     ',
									\':exe "FufJumpList                     " |" so     ',
									\':exe "FufChangeList                   " |" sp     ',
									\':exe "FufQuickfix                     " |" sq     ',
									\':exe "FufLine                         " |" sy     ',
									\':exe "FufHelp                         " |" sh     ',
									\':exe "FufEditDataFile                 " |" se     ',
									\':exe "FufRenewCache                   " |" sr     ',
									\':exe "FufDir ~/"                        |" Change DIR from home',
									\':exe "FufFile ~/"                       |" Open file form home',
									\]


nnoremap <silent> <S-F4> :call fuf#givencmd#launch('', 0, 'Select Command>', GetAllCommands())<CR>
nnoremap <silent> <F4> :call fuf#givencmd#launch('', 0, 'Select Command>', g:fuf_com_list)<CR>
"}}}



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tSkeleton Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tskelMarkerLeft    = "<!"
let g:tskelMarkerRight   = "!>"
"<+DATE+>
let g:tskelDateFormat = "%m/%d/%Y %T, %Wth %A"

"<+AUTHOR+>
let g:tskelUserName = 'emux'

"<+EMAIL+>
let g:tskelUserEmail = 'emuxevans@126.com'

"<+WEBSIET>
let g:tskelUserWWW = 'www.emuxevans.com'

"<+LICENSE+>
let g:tskelLicense = 'CopyRight (c) www.emuxevans.com 2013. All Rights Reserved.'

autocmd BufNewFile *.pl TSkeletonSetup perl.pl

"nnoremap <silent> <c-b> :call tskeleton#GoToNextTag()<cr>
"inoremap <silent> <c-b> <esc>:call tskeleton#GoToNextTag()<cr>
"vnoremap <silent> <c-b> :call tskeleton#GoToNextTag()<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" window resize Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"resize horzontal split window
nmap <C-Left> <C-W><<C-W><
nmap <C-Right> <C-W>><C-W>>

"resize vertical split window
nmap <C-Down> <C-W>-<C-W>-
nmap <C-Up> <C-W>+<C-W>+


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" automatically chmod +x Shell/Perl/Expect/Tcl Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
	au BufUnload *.pl !chmod +x %
	au BufUnload *.sh !chmod +x %
	au BufUnload *.exp !chmod +x %
	au BufUnload *.tcl !chmod +x %
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Grep.vim Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>s :Rgrep<CR>
let Grep_Default_Filelist = '*.c *.h *.S *.cpp *.asm'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CppUTest.vim Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:CppUTestDefaultType = 'cpp'
function! CppUTest_EditFunction()
  "Copy interface specify from x register which :Dox command has copied
  exec "normal \"xp"

  "Remove ;
  exec ":s/;//eg"

  "Append {
  exec "normal o{\<cr>\<tab>\<left>"
  exec "startinsert"
endfunction
nmap <leader>un :call CppUTest_UnittestNew()<CR>
imap <leader>un <Esc>:call CppUTest_UnittestNew()<CR>
nmap <leader>ua :call CppUTest_UnittestAdd()<CR>
imap <leader>ua <Esc>:call CppUTest_UnittestAdd()<CR>
nmap <leader>uap :call CppUTest_UnittestAddCpp()<CR>
imap <leader>uap <Esc>:call CppUTest_UnittestAddCpp()<CR>
nmap <leader>ur :call CppUTest_UnittestRun()<CR>
imap <leader>ur <Esc>:call CppUTest_UnittestRun()<CR>
nmap <leader>up :call CppUTest_UnittestPerform()<CR>
imap <leader>up <Esc>:call CppUTest_UnittestPerform()<CR>
nmap <C-p> :call CppUTest_EditFunction()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" superTab.vim Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = '<c-x><c-u>'
let g:SuperTabMappingForward = '<c-k>'
let g:SuperTabMappingBackward = '<s-c-k>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clan_complete.vim Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:clang_user_options='-stdlib=libstdc++ -std=c++11 -I/usr/include'
"let g:clang_periodic_quickfix=1
let g:clang_close_preview=1

if version >= 703
  set conceallevel=2
  set concealcursor=vin
endif

"disable-preview-scratch-window
set completeopt=menu,longest
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_complete_copen=1
let g:clang_hl_errors=1
let g:clang_auto_user_options = '.clang_complete'
let g:clang_complete_macros = 1
let g:clang_complete_patterns = 1
let g:clang_sort_algo = ''
let g:clang_auto_select = 1
let g:clang_complete_auto=1

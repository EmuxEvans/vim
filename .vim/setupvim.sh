#!/bin/sh
# @file setupvim.sh <User> <Email> <Web> <Company>
# @brief Setup the copyright for .vimrc
# @usage ./setupvim.sh  "linkihome.com"
# @author emux, emuxevans@126.com
# @version 1.0.0
# @date 05/15/2012 06:42:55, 20th Tuesday
# @copyright Copyright (c) linkihome.com 2012. All rights reserved.
# @reference

vimrc=~/.vimrc;
csupport=~/.vim/c-support/templates/Templates;

if [ $# -ne 4 ];then
	echo "$0 <User> <Email> <Web> <Company>";
	exit 1;
fi

year=`date +"%Y"`;
copyright="CopyRight (c) $4 $year. All Rights Reserved.";



#Setup $vimrc
sed -i -e "s/\(let g:tskelUserName =\) \('.*'\)/\1 '$1'/g" \
		-e "s/\(let g:tskelUserEmail =\) \('.*'\)/\1 '$2'/g" \
		-e "s/\(let g:tskelUserWWW =\) \('.*'\)/\1 '$3'/g" \
		-e "s/\(let g:tskelLicense =\) \('.*'\)/\1 '$copyright'/g" \
		-e "s/\(let g:DoxygenToolkit_authorName=\)\('.*'\)/\1'$1, $2'/g" $vimrc

#Setup c-support
sed -i -e "s/\(|AUTHOR.*=\) \(.*\)/\1 '$1'/g" \
		-e "s/\(|AUTHORREF.*=\) \(.*\)/\1 '$1'/g" \
		-e "s/\(|EMAIL.*=\) \(.*\)/\1 '$2'/g" \
		-e "s/\(|COMPANY.*=\) \(.*\)/\1 '$4'/g" $csupport

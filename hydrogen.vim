" Vim syntax file
" Hydrogen:	Hydrogen, python script for hydrogen (notebook-like script)
" Maintainer:	Mogami, Shinichi <mogamin1st@gmail.com>
" LastChange:	22 Feb 2019
" Original:	Comes from python.vim

" quit when a syntax file was already loaded
" if exists("b:current_syntax")
"    finish
" endif

" This syntac file is a first attempt. It is far from perfect...

" Uses python.vim, and adds a few special things for Hydrogen special
" comments.
" Those files usually have the extension  *.py, so we need to set this syntax
" manually.

" source the java.vim file
runtime! syntax/python.vim
unlet b:current_syntax

syn match hydrogenSeparator	"#\s%%.*$"
syn region hydrogenMarkdownCell
      \ start="^#\s%% \[markdown\]" end="^\s*$"

hi def link hydrogenSeparator		Define
hi def link hydrogenMarkdownCell	Define

let b:current_syntax = "hydrogen"

" vim:set sw=2 sts=2 ts=8 noet:

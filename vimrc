set wildmenu
set wildmode=list:longest
set backspace=2
set showmode
set nocompatible
set expandtab
set shiftwidth=2
set tabstop=2
set hidden
imap kj <esc>
nnoremap <Space> i_<Esc>r
set number
syntax on
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'carakan/new-railscasts-theme'
Plugin 'shmup/vim-sql-syntax'
Plugin 'vim-scripts/Conque-Shell'
Plugin 'othree/yajs.vim'
Plugin 'othree/es.next.syntax.vim'
Plugin 'tpope/vim-surround'
Plugin 'easymotion/vim-easymotion'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'valloric/youcompleteme'
Plugin 'terryma/vim-multiple-cursors'
call vundle#end()
colorscheme new-railscasts
filetype plugin indent on
map <leader>n :NERDTreeToggle<CR>

func! Shebang(path)
        echo a:path
        if a:path =~ ".*\.sh"
                normal i#!/bin/bash
        endif
endfunc
autocmd BufNewFile *.sh execute Shebang(expand('<amatch>'))

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

nnoremap <C-h> :bp<Enter>
nnoremap <C-l> :bn<Enter>
function! s:closeAndNext()
  let buf = bufnr('%')
  bn
  execute "bd" . buf
endfunction
command! Q call s:closeAndNext()

function! s:s3edit(file)
    let file = substitute(a:file, '^s3://', '\1', '')
    let tempFile = substitute(system('mktemp'), '\n$', '\1', '')
    execute "silent! !aws s3 cp s3://" . file . " " . tempFile
    execute "silent! edit " . tempFile
    let buf = bufnr('%')
    execute "au BufWritePost <buffer=" . buf . "> silent! !aws s3 cp '" . tempFile . "' 's3://" . file . "'"
    execute "au BufLeave <buffer=" . buf . "> silent! !rm " . tempFile
endfunction
au FileReadCmd s3://* call s:s3edit(expand("<amatch>"))
au BufReadCmd s3://* call s:s3edit(expand("<amatch>"))


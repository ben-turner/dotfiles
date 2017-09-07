" Plugins
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
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-dispatch'
Plugin 'chr4/nginx.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'takac/vim-hardtime'
call vundle#end()

" Settings
set relativenumber
set wildmenu
set wildmode=list:longest
set backspace=2
set showmode
set nocompatible
set expandtab
set shiftwidth=2
set tabstop=2
set hidden
set number
syntax on
filetype off
filetype plugin indent on
colorscheme new-railscasts

" Mappings
" Global
noremap <leader>n :NERDTreeToggle<CR>

" Normal
nnoremap <Space> i_<Esc>r
nnoremap <C-k> O<Esc>0D
nnoremap <C-j> o<Esc>0D
nnoremap <C-h> <Esc>:bp<Enter>
nnoremap <C-l> <Esc>:bn<Enter>
nnoremap <leader>ga :Gwrite<cr>
nnoremap <leader>gc :Gcommit -v -q<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gbr :Git branch<space>
nnoremap <leader>gco :Git checkout<space>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gl :Gpull<cr>
nnoremap <leader>r :set invrelativenumber<cr>
nnoremap <leader>l :set invlist<cr>
nnoremap <leader>h :HardTimeToggle<cr>

" Functions
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


" Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'carakan/new-railscasts-theme'
Plugin 'shmup/vim-sql-syntax'
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
Plugin 'bkad/CamelCaseMotion'
Plugin 'elmindreda/vimcolors'
Plugin 'sickill/vim-monokai'
Plugin 'vim-airline/vim-airline'
Plugin 'edkolev/promptline.vim'
Plugin 'tpope/vim-rhubarb'
Plugin 'christianrondeau/vim-base64'
Plugin 'posva/vim-vue'
call vundle#end()
call camelcasemotion#CreateMotionMappings('<leader>')

" Settings
set title
set laststatus=2
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
set guicursor=
syntax on
filetype off
filetype plugin indent on
colorscheme monokai

" Lettings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1
let NERDTreeShowLineNumbers=1
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let g:hardtime_default_on=1
let g:hardtime_maxcount=2

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
nnoremap <leader>gh :Gbrowse<cr>
nnoremap <leader>h :HardTimeToggle<cr>
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>f :NERDTreeFind<cr>
nnoremap <leader>t :belowright new<cr>:te<cr>a
nnoremap <leader>T :tab new<cr>:te<cr>a
nnoremap <leader>s :tab new<cr>:te ssh<space>
nnoremap <leader>r :belowright new<cr>:te npm run dev<cr>
nnoremap <leader>v :tabedit ~/Projects/src/github.com/ben-turner/dotfiles/vimrc<cr>
nnoremap gn :tabe<cr>
nnoremap <leader>N :set invrelativenumber<cr>

" Terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

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

aug vimrc
  au!
  au FileReadCmd,BufReadCmd s3://* call s:s3edit(expand("<amatch>"))
  au FileType vim au FileWritePost,BufWritePost <buffer> source %
  au FileReadCmd *.vue set syntax=html
aug END


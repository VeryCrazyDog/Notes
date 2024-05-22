"
" My .vimrc
"

" Inherit from default configuration
" https://vimhelp.org/starting.txt.html#defaults.vim 
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" Disable all mouse modes
" https://vimhelp.org/options.txt.html#%27mouse%27
set mouse-=a

" Number of spaces that a tab character in the file counts for
" https://vimhelp.org/options.txt.html#%27tabstop%27
set tabstop=2

" Number of spaces to use for each step of indent when using indent command such as `>>`
" https://vimhelp.org/options.txt.html#%27shiftwidth%27
set shiftwidth=2

" Ignore case in search patterns
" https://vimhelp.org/options.txt.html#%27ignorecase%27
set ignorecase

" When there is a previous search pattern, highlight all its matches
" https://vimhelp.org/options.txt.html#%27hlsearch%27
set hlsearch

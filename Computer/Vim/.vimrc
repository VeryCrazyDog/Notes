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

" Ignore case in search patterns
" https://vimhelp.org/options.txt.html#%27ignorecase%27
set ignorecase

" When there is a previous search pattern, highlight all its matches
" https://vimhelp.org/options.txt.html#%27hlsearch%27
set hlsearch

" Load color scheme
" https://vimhelp.org/syntax.txt.html#%3Acolorscheme
colorscheme evening

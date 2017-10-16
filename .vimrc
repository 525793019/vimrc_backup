filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"################  Plugin  ##################
" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)

" 代码折叠
Plugin 'tmhedberg/SimpylFold'

" 自动缩进
Plugin 'vim-scripts/indentpython.vim'

" 检查语法
Plugin 'scrooloose/syntastic'

" PEP8代码风格
Plugin 'nvie/vim-flake8'

" 树型目录
Plugin 'scrooloose/nerdtree'

" 自动补全 
Plugin 'Valloric/YouCompleteMe'

Plugin 'davidhalter/jedi-vim'

" 状态栏
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"##################  Set  ##################
" 编码模式
set encoding=utf-8 

" 不兼容vi模式
set nocompatible              " required

" 设置backspace模式（0,1,2）
set backspace=2

" 现实行号
set nu

" n模式下p键粘贴系统剪贴板
set clipboard=unnamedplus

"/ ? 搜索高亮
set hlsearch 

hi Search term=standout ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey

" 设置缩进参数
highlight BadWhitespace ctermbg=blue guibg=blue

au BufNewFile,BufRead *.html
\ set tabstop=4 |
\ set textwidth=100 | 

au BufNewFile,BufRead *.py
\ set tabstop=4 |
\ set softtabstop=4 |
\ set shiftwidth=4 |
\ set textwidth=79 |
\ set expandtab |
\ set autoindent |
\ set fileformat=unix |

au BufNewFile,BufRead *.js, *.html, *.css
\ set tabstop=2 |
\ set softtabstop=2 |
\ set shiftwidth=2 |

" 显示多余空白符
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"##################  Map  ##################


"##################  Let g:  ##################
" 语法高亮
let python_highlight_all=1
syntax on

"##################  窗口分割  ##################
" 设置打开新窗口在下方，右侧
set splitbelow
set splitright

" n模式下切换窗口快捷键
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"##################  代码折叠  ##################
" 设置代码折叠
set foldmethod=indent
set foldlevel=99

" space折叠/展开代码
nnoremap <space> za

" 显示折叠代码的文档字符串
let g:SimpylFold_docstring_preview=1

"##################  树型目录  ##################
"NERDTree快捷键

map <F2> :NERDTreeMirror<CR>
map <F2> :NERDTreeToggle<CR>
" NERDTree.vim
let g:NERDTreeWinPos="left"
let g:NERDTreeWinSize=30
let g:NERDTreeShowLineNumbers=1
let g:neocomplcache_enable_at_startup = 1 

let NERDTreeMinimalUI=1 "不显示帮助面板

"##################  语法检测  ##################
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers=['pyflakes']

"##################  自动补全  ##################

" 自动补全窗口不自动消失
let g:ycm_autoclose_preview_window_after_completion=1

" 解决YCM的Tab冲突
let g:ycm_key_list_select_completion = ['j']
let g:ycm_key_list_previous_completion = ['k']

" 跳转定义处
nnoremap <C-A>  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" 符号配对
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

inoremap ) <C-R>=Matching(')')<CR>
inoremap ] <C-R>=Matching(']')<CR>
inoremap } <C-R>=Matching('}')<CR>

" Tab跳过右侧匹配符号
inoremap <Tab> <C-R>=TabSkip()<CR>

" backspace
inoremap <BS> <C-R>=DelPair()<CR>

function TabSkip()
    let char = getline('.')[col('.') - 1]
    if char == '}' || char == ')' || char == ']' || char == ';'|| char == '"' || char == "'"
        return "\<Right>"
    else
        return "\<Tab>"
    endif
endf

" 成对删除
function DelPair()
    let c1 = getline('.')[col('.') - 2]
    let c2 = getline('.')[col('.') - 1]
    if c1 == '(' && c2 == ')' || c1 == '[' && c2 == ']' || c1 == '{' && c2 == '}' || c1 == '"' && c2 == '"' || c1 == "'" && c2 == "'" 
        return "\<Right>\<BS>\<BS>"
    else
        return "\<BS>"
    endif
endf

" 匹配右侧符号，如果存在就不再生成
function Matching(c)  
    let char = getline('.')[col('.') - 1]
    if char == '}' || char == ')' || char == ']'
        return "\<Right>"
    else
        return a:c
    endif
endf


" 快速运行
map <F5> :call CompileRunGcc()<CR>

func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
"        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
endfunc
    
" jedi-vim seting
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = "left"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = "1"



" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

set ambiwidth=double
set backspace=2
set tabstop=2
set textwidth=0
set shiftwidth=2
set expandtab

set number
set ruler
set smartindent
set showmatch
set showmode
set shellslash
set ff=unix
set nobackup
set noswapfile
set hlsearch
set ignorecase
set paste

syntax on
filetype plugin on
filetyp  indent on

" シンタックスチェック機能
nmap ,l :call SyntaxCheck()<CR>
nmap ,e :call ExecuteCode()<CR>
nmap ,t :call ExecuteTest()<CR>

function SyntaxCheck()
  execute ":w"
  if ("php" == &filetype)
    echo system("php -l ".bufname(""))
  elseif ("ruby" == &filetype)
    echo system("ruby -c ".bufname(""))
  elseif ("yaml" == &filetype)
    echo system('ruby -ryaml -e "begin;YAML::load(open(\"'.bufname("").'\",\"r\").read); puts \"ok\"; rescue ArgumentError => e; puts e; end"')
  end
endfunction

function ExecuteCode()
  execute ":w"
  if ("php" == &filetype)
    execute ":! php %"
  elseif ("ruby" == &filetype)
    execute ":! ruby %"
  end
endfunction

function ExecuteTest()
  execute ":w"
  if ("php" == &filetype)
    execute ":! phpunit --colors %"
  end
endfunction

" space可視化の呪文 (ref. http://d.hatena.ne.jp/potappo2/20061107/1162862536)
syntax match InvisibleJISX0208Space "　" display containedin=ALL
highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=Blue
syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=Red
syntax match InvisibleTab "\t" display containedin=ALL
highlight InvisibleTab term=underline ctermbg=Cyan guibg=Cyan

if has("syntax")
    syntax on
    function! ActivateInvisibleIndicator()
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=Blue
        syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
        highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=Red
        syntax match InvisibleTab "\t" display containedin=ALL
        highlight InvisibleTab term=underline ctermbg=Cyan guibg=Cyan
    endf

    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif

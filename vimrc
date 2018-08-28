set nocompatible
"set textwidth=100
set smartindent
set autoindent
set shiftwidth=4
set tabstop=4
set noexpandtab
set wildignore=*.o,*.bak
set laststatus=2
set nolist
let Tlist_Inc_Winwidth=0
:ab #i #include
:ab #d #define
:ab #e #endif
:map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
:map <F2> dwwp
:nnoremap <F5> :buffers<CR>:buffer<Space>
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
:vnoremap < <gv
:vnoremap > >gv
":map tt <Esc>:TlistToggle<CR>
:nmap <Tab> gt
:nmap <s-tab> gT
:hi comment ctermfg=darkcyan
:set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ %{'tabn:'.tabpagenr()}\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
set background=light

au! BufRead,BufNewFile *.json set filetype=json 

augroup json_autocmd 
    autocmd! 
    autocmd FileType json set autoindent 
    autocmd FileType json set formatoptions=tcq2l 
    autocmd FileType json set textwidth=78 shiftwidth=2 
    autocmd FileType json set softtabstop=2 tabstop=8 
    autocmd FileType json set expandtab 
    autocmd FileType json set foldmethod=syntax 
augroup END



if $TMUX == ''
    set clipboard+=unnamed
else 
    set clipboard=exclude:.*
endif

if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
      inoremap <silent> <C-[>OC <RIGHT>
endif
"Settings for the line pointed by cursor
"highlight CursorLine term=bold cterm=bold ctermfg=124 ctermbg=187 gui=bold guifg=Blue guibg=LightCyan
color default "Not using fancy solarized
highlight clear SpellBad
set nospell
highlight  SpellBad cterm=underline
highlight CursorLine   term=bold cterm=bold ctermfg=Blue ctermbg=LightGray
"highlight LineNr       term=bold cterm=bold ctermfg=245  ctermbg=187
highlight LineNr       term=bold cterm=bold ctermfg=LightBlue ctermbg=0
highlight CursorLineNr term=bold cterm=bold ctermfg=DarkRed ctermbg=0

fun! TWS()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun

:noremap <Leader>w :call TWS()<CR>

if &diff
    colorscheme dusk
endif

set colorcolumn=


"
" Created based on spf-13 and using vundle
"
"
" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    "za }

" }

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    " let g:no_autochdir = 1
    if !exists('g:no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:no_restore_cursor = 1
    if !exists('g:no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

	if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
	      inoremap <silent> <C-[>OC <RIGHT>
	endif
" }

" funtions {
	fun! TWS()
	    let l:save = winsaveview()
	    %s/\s\+$//e
	    call winrestview(l:save)
	endfun

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }
	
    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }
" }

" UI {
	"Settings for the line pointed by cursor
	color default 						"Not using fancy solarized
	highlight 	clear SpellBad
    highlight 	clear SignColumn      " SignColumn should match background
	highlight  	SpellBad 		cterm=underline
	highlight 	CursorLine   	term=bold cterm=bold ctermfg=Blue 		ctermbg=LightGray
	highlight 	LineNr       	term=bold cterm=bold ctermfg=LightBlue 	ctermbg=0
	highlight 	CursorLineNr 	term=bold cterm=bold ctermfg=DarkRed 	ctermbg=0

    set showmode                    " Display the current mode

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    "if has('statusline')
    "    set laststatus=2

    "    " Broken down into easily includeable segments
    "    set statusline=%<%f\                     " Filename
    "    set statusline+=%w%h%m%r                 " Options
    "    if !exists('g:override_spf13_bundles')
    "        set statusline+=%{fugitive#statusline()} " Git Hotness
    "    endif
    "    set statusline+=\ [%{&ff}/%Y]            " Filetype
    "    set statusline+=\ [%{getcwd()}]          " Current dir
    "    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    "endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
	set foldmarker={,}
	set foldmethod=marker
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Mapping {

	let mapleader = ','
	:nmap <Tab> gt
	:nmap <s-tab> gT
    noremap j gj
    noremap k gk
	:noremap <Leader>w :call TWS()<CR>

	set smartindent
	set autoindent
	set shiftwidth=4
	set tabstop=4
	set softtabstop=4               " Let backspace delete indent
	set noexpandtab
	set wildignore=*.o,*.bak,*.class,*.pyc
	set laststatus=2
	set nolist
	set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
	set splitright                  " Puts new vsplit windows to the right of the current
	set splitbelow                  " Puts new split windows to the bottom of the current
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:keep_trailing_whitespace') | call StripTrailingWhitespace() | endif

    " Stupid shift key fixes
	command! -bang -nargs=* -complete=file E e<bang> <args>
	command! -bang -nargs=* -complete=file W w<bang> <args>
	command! -bang -nargs=* -complete=file Wq wq<bang> <args>
	command! -bang -nargs=* -complete=file WQ wq<bang> <args>
	command! -bang Wa wa<bang>
	command! -bang WA wa<bang>
	command! -bang Q q<bang>
	command! -bang QA qa<bang>
	command! -bang Qa qa<bang>
	"Typo correction while opening multiple files
	" Tabe file1 file2 file3
    cmap Tabe tabe	

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    "nmap <leader>f0 :set foldlevel=0<CR>
    "nmap <leader>f1 :set foldlevel=1<CR>
    "nmap <leader>f2 :set foldlevel=2<CR>
    "nmap <leader>f3 :set foldlevel=3<CR>
    "nmap <leader>f4 :set foldlevel=4<CR>
    "nmap <leader>f5 :set foldlevel=5<CR>
    "nmap <leader>f6 :set foldlevel=6<CR>
    "nmap <leader>f7 :set foldlevel=7<CR>
    "nmap <leader>f8 :set foldlevel=8<CR>
    "nmap <leader>f9 :set foldlevel=9<CR>

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
	:map <F2> dwwp

    " Easier horizontal scrolling
    map zl zL
    map zh zH

	if &diff
	    colorscheme dusk
	endif
" }


" Plugins {
	" Plugin specific onnfig goes here
	"
	" hardtime {
		nnoremap <leader>h :HardTimeToggle<CR>
		let g:hardtime_timeout = 2000
		let g:hardtime_showmsg = 1
		let g:hardtime_allow_different_key = 1
	" }
	" NerdTree {
		map <C-e> <plug>NERDTreeTabsToggle<CR>
		map <leader>e :NERDTreeFind<CR>
		nmap <leader>nt :NERDTreeFind<CR>

		let NERDTreeShowBookmarks=1
		let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
		let NERDTreeChDirMode=0
		let NERDTreeQuitOnOpen=1
		let NERDTreeMouseMode=2
		let NERDTreeShowHidden=1
		let NERDTreeKeepTreeInNewTab=1
		let g:nerdtree_tabs_open_on_gui_startup=0
	" }
	" limelight {
		" Color name (:help cterm-colors) or ANSI code
		let g:limelight_conceal_ctermfg = 'gray'
		let g:limelight_conceal_ctermfg = 240

		" Color name (:help gui-colors) or RGB color
		let g:limelight_conceal_guifg = 'DarkGray'
		let g:limelight_conceal_guifg = '#777777'

		" Default: 0.5
		let g:limelight_default_coefficient = 0.7

		" Number of preceding/following paragraphs to include (default: 0)
		let g:limelight_paragraph_span = 1

		" Beginning/end of paragraph
		"   When there's no empty line between the paragraphs
		"   and each paragraph starts with indentation
		let g:limelight_bop = '^\s'
		let g:limelight_eop = '\ze\n^\s'

		" Highlighting priority (default: 10)
		"   Set it to -1 not to overrule hlsearch
		let g:limelight_priority = -1

		"nmap <leader>l <Plug>(Limelight)
		"xmap <leader>l <Plug>(Limelight)
	"}
" }
" Unexplored {
    " Easier formatting
   "nnoremap <silent> <leader>q gwip
   ":nnoremap <F5> :buffers<CR>:buffer<Space>
   ":nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
   ":map tt <Esc>:TlistToggle<CR>
	":hi comment ctermfg=darkcyan
	":set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ %{'tabn:'.tabpagenr()}\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
	"set background=light
	"
	"
	"if $TMUX == ''
	"    set clipboard+=unnamed
	"else 
	"    set clipboard=exclude:.*
	"endif
	"
	"
	"
	"
" }

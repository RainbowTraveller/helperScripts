# Instructions to enable italics on Mac OS Iterm2 and Linux

1. Copy files to your machine
```
xterm-256color.terminfo
terminfo tmux-256color.terminfo
```
2. Execute following command using these files

```
tic -o ~/.terminfo xterm-256color.terminfo
tic -o ~/.terminfo tmux-256color.terminfo
```

3. Add .vimrc following, make sure font is installed using `Plug`
```
"Sublime-Monokai {
    "folliwing 2 lines are necessary for linux and not Mac OS
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    let g:sublimemonokai_term_italic = 1
    colorscheme sublimemonokai
    let java_comment_strings = 1
    let java_highlight_functions = 1
    let java_highlight_java_lang_ids = 1
"}
```

4. add to .tmux.conf

In linux it fails for screen term
`set -g default-terminal "screen-256color"`

So try this
`set -g default-terminal "xterm-256color"`

and for linux add this too

`set -as terminal-overrides ',xterm*:Tc:sitm=\E[3m'`


5. Also add this to vimrc
 : is achieved by Ctrl + V + Esc

set t_ZH=^[[3m
set t_ZR=^[[23m

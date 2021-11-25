#!/bin/sh
GIT_REPO="mmrose/dotfiles"
GIT_BRANCH="master"

## Check for git and curl
if ! [ -x "$(command -v git)" ] || ! [ -x "$(command -v curl)" ]; then
  echo 'Install both: git and curl.' >&2
  exit 1
fi

## Remove omz if present
if [ -d "~/.oh-my-zsh" ]; then
    rm -rf ~/.oh-my-zsh
    ## Remove symlinks
    for SYMLINK in $(find $HOME -type l); do
        case $(readlink $SYMLINK) in
            $DOTFILES*) 
                echo "Removing symlink $SYMLINK"
                rm $SYMLINK
                ;;
        esac
    done
fi

## Grab dotfiles
if [ -d "~/.dotfiles" ]; then
    rm -rf ~/.dotfiles
fi

# zsh with zinit
cat <<-"EOF" > ~/.zshrc
#! zsh

# basics
export EDITOR='vim'
# fixing zsh issues in tmux
bindkey -e
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PATH="$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH"
export LS_COLORS=$LS_COLORS:'di=0;36:'
# see here: https://gist.github.com/zanshin/4848f55ef103ac039531
export LSCOLORS=gxfxcxdxbxegedabagacad

export PURE_CMD_MAX_EXEC_TIME=1

# history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt HIST_VERIFY
setopt EXTENDED_HISTORY      # save each command's beginning timestamp and the duration to the history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY    # this is default, but set for share_history
setopt SHARE_HISTORY         # Share history file amongst all Zsh sessions

# tools
alias tm='tmux -2 attach || tmux -2 new'
alias ls='ls -lah --color'

# network and processes
alias psg='ps aux | grep -v grep | grep -i'
alias nsl='netstat -taupn | grep LISTEN'
alias nsg='netstat -taupn | grep -i'

# update shell
alias update-dotfiles="curl -sL https://raw.githubusercontent.com/mmrose/dotfiles/master/install.sh | sh"

# plugin stuff
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=~/.cache}

typeset -A ZPLGM
ZPLG_HOME=$XDG_CACHE_HOME/zsh/zinit
ZPLGM[HOME_DIR]=$ZPLG_HOME
ZPLGM[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

if [[ ! -f $ZPLG_HOME/bin/zinit.zsh ]]; then
  git clone https://github.com/zdharma-continuum/zinit.git $ZPLG_HOME/bin
  zcompile $ZPLG_HOME/bin/zinit.zsh
fi
source $ZPLG_HOME/bin/zinit.zsh
load=light

# dependency: async jobs
zinit $load mafredri/zsh-async
# sane base options
zinit $load willghatch/zsh-saneopt
# jump around in popular directories
zinit $load rupa/z

# prompt
zinit $load sindresorhus/pure

# colors for ls
zinit ice nocompile:! pick:c.zsh atpull:%atclone atclone:'dircolors -b LS_COLORS > c.zsh'
zinit $load trapd00r/LS_COLORS

# autocomplete based on history
zinit ice silent wait:1 atload:_zsh_autosuggest_start
zinit $load zsh-users/zsh-autosuggestions
zinit ice blockf; zinit $load zsh-users/zsh-completions

# syntax highlighting
zinit ice silent wait!1 atload"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit"
zinit $load zdharma-continuum/fast-syntax-highlighting

# Print command exit code as a human-readable string
zinit $load bric3/nice-exit-code
export RPS1='%B%F{red}$(nice_exit_code)%f%b'

zinit snippet OMZ::lib/completion.zsh

zstyle :prompt:pure:path   color        cyan
zstyle ':completion:*'     special-dirs true

# add kubectl completions
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# npm
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

if [ -f ~/.zsh_alias_local ]; then
    source ~/.zsh_alias_local
fi
EOF

# tmux
cat <<-"EOF" > ~/.tmux.conf
# basic settings
set -g history-limit 50000
set -g default-terminal "screen-256color"
set -g base-index 1
setw -g pane-base-index 1
setw -g automatic-rename off
set-environment -g CHERE_INVOKING 1

# use C-a instead of C-b
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# intuitive pane creation
bind | split-window -h
bind - split-window -v

# broadcast toggle
bind b setw synchronize-panes

# Smart pane switching vim-style
bind -n C-h select-pane -L
bind -n C-j select-pane -D
bind -n C-k select-pane -U
bind -n C-l select-pane -R

# Window navigation
bind -n C-w previous-window
bind -n C-e next-window

# mouse with 3-line-scoll
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M; send-keys -M; send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M; send-keys -M; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M \; send-keys -M \; send-keys -M

# style
set -g message-style fg=colour145,bg=colour236
set -g message-command-style fg=colour145,bg=colour236
set -g pane-active-border-style fg=colour25,bg=colour25
set -g pane-border-style fg=colour233,bg=colour234
set -g window-style fg=colour247,bg=colour234
set -g window-active-style fg=colour250,bg=colour233
set -g status "on"
set -g status-style bg=colour233,none
set -g status-justify "centre"
set -g status-left "#[fg=colour195,bg=colour25,bold] #(whoami)@#H #[fg=colour25,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour145,bg=colour236] #S #[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]"
set -g status-left-style none
set -g status-left-length "100"
set -g status-right "#[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]#[fg=colour145,bg=colour236] %F #[fg=colour25,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour195,bg=colour25] %R "
set -g status-right-style none
set -g status-right-length "100"
setw -g window-status-activity-style fg=colour25,bg=colour233,none
setw -g window-status-style fg=colour240,bg=colour233,none
setw -g window-status-current-format "#[fg=colour233,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour145,bg=colour236] #I #W #[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]"
setw -g window-status-format "#[fg=colour233,bg=colour233,nobold,nounderscore,noitalics]#[default] #I #W #[fg=colour233,bg=colour233,nobold,nounderscore,noitalics]"
setw -g window-status-separator ""
EOF

# vim
touch ~/.vimrc
cat <<-"EOF" > ~/.vimrc
set nocompatible
syntax on

if exists('+colorcolumn')
  highlight ColorColumn ctermbg=235 guibg=#2c2d27
  let &colorcolumn="80,120"
endif

let mapleader=","
let maplocalleader="\\"

set nowrap
set tabstop=2
set softtabstop=2
set expandtab
set copyindent
set number
set shiftwidth=2
set shiftround
set showmatch
set smartcase
set ignorecase
set hlsearch
set pastetoggle=<F2>
set splitbelow
set splitright

set mouse+=a
if &term =~ '^screen'
  set ttymouse=xterm2
endif

set hidden
set nobackup
set noswapfile
set wildmode=list:full
set wildignore=*.swp,*.bak,*.pyc,*.class
set visualbell
set nomodeline
set cursorline
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

nnoremap <leader>s :w<CR>
inoremap <leader>s <Esc>:w<CR>
nnoremap ; :
nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>
nmap <silent> ,/ :nohlsearch<CR>
cmap w!! w !sudo tee % >/dev/null
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnorema <leader>lu :set ff=unix<CR>
EOF

# npm
if [ -x "$(command -v npm)" ]; then
  mkdir -p ~/.npm-packages
  npm config set prefix ~/.npm-packages
fi

mkdir -p ~/.config/htop
cat <<-"EOF" > ~/.config/htop/htoprc
# Beware! This file is rewritten by htop when settings are changed in the interface.
# The parser is also very primitive, and not human-friendly.
fields=0 48 17 18 38 39 40 2 46 47 64 49 1 
sort_key=46
sort_direction=1
hide_threads=0
hide_kernel_threads=0
hide_userland_threads=0
shadow_other_users=0
show_thread_names=0
highlight_base_name=1
highlight_megabytes=1
highlight_threads=1
tree_view=0
header_margin=1
detailed_cpu_time=1
cpu_count_from_zero=0
update_process_names=0
account_guest_in_cpu_meter=1
color_scheme=0
delay=15
left_meters=AllCPUs Memory Swap 
left_meter_modes=1 1 1 
right_meters=Tasks LoadAverage Uptime 
right_meter_modes=2 2 2 
EOF

cat <<-"EOF" > ~/.gitconfig
[core]
#    autocrlf = true
    eol = lf
    filemode = false
[credential]
    helper = cache --timeout=846000
[user]
    name = Martin Mrose
[push]
    default = tracking

# include data not shared in my dotfiles
[include]
    path = ~/.gitconfig.local
EOF

exit 0;

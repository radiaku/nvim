# ln -s ~/.config/nvim/.zshrc ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="ubunly"
ZSH_THEME="jovial"
# ZSH_THEME="suvash"
# ZSH_THEME="kali-like"


plugins=(
  git
  zsh-syntax-highlighting
  zsh-autocomplete
  z
)


source $ZSH/oh-my-zsh.sh


# Remove any existing alias
unalias fzf-cd 2>/dev/null

alias fzf-cd="cd ~ && cd \$(find ~/Dev -type d \( -name node_modules -o -name .git \) -prune -o -name '*'  -type d -print | fzf)"

# Create a zsh widget
zle -N fzf-cd
bindkey '^F' fzf-cd

HISTFILE=~/.zsh-histfile
HISTSIZE=999999999

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# default editor to vim
export VISUAL=vim
export EDITOR="$VISUAL"

export PATH=/usr/lib/postgresql/15/bin:$PATH

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/meradia/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
export PATH="$PATH:$HOME/.local/bin"
autoload bashcompinit
bashcompinit
source "/home/meradia/.local/share/bash-completion/completions/am"

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

# alias fzf-cd="cd ~ && cd \$(find ~/Dev --max-depth 2 -type d \( -name node_modules -o -name .git \) -prune -o -name '*'  -type d -print | fzf)"
#
# Define the fzf-cd function to search only for directories in ~/Dev, skipping node_modules and .git, limited to 2 levels deep
fzf-cd() {
  local fd_options fzf_options target

  fd_options=(
    --type directory
    --max-depth 2
  )

  fzf_options=(
    --preview='tree -L 1 {}'
    --bind=ctrl-space:toggle-preview
    --exit-0
  )

  # Search for directories inside ~/Dev, using fd with correct pattern
  target="$(fd . ~/Dev "${fd_options[@]}" | fzf "${fzf_options[@]}")"

  # Ensure the result is a directory (strip filename if it's selected)
  test -f "$target" && target="${target%/*}"

  # Change to the selected directory
  cd "$target" && zle && zle reset-prompt || return 1
  # cd "$target" || return 1

  # Force prompt to refresh by re-sourcing the prompt information
  # VIRTUAL_ENV_DISABLE_PROMPT=1; # Optional to avoid virtualenv prompt interfering
  # source ~/.zshrc  # Re-source .zshrc to refresh the prompt
}


ff() {
    local fd_options fzf_options target

    fd_options=(
        --type directory
        --max-depth 2 
    )

    fzf_options=(
        --preview='tree -L 1 {}'
        --bind=ctrl-space:toggle-preview
        --exit-0
    )

    target="$(fd . "${1:-.}" "${fd_options[@]}" | fzf "${fzf_options[@]}")"

    test -f "$target" && target="${target%/*}"

    cd "$target" || return 1
}

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

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

# User configuration
# Always work in a tmux session if tmux is installed
# https://github.com/chrishunt/dot-files/blob/master/.zshrc
# if which tmux 2>&1 >/dev/null; then
#   # Check if we are not in a tmux session
#   if [ "$TERM" != "screen-256color" ] && [ "$TERM" != "screen" ]; then
#     # Check if the tmux session "hack" exists
#     if tmux has-session -t hack 2>/dev/null; then
#       # If it exists, attach to it
#       tmux attach -t hack
#     else
#       # If it doesn't exist, create it
#       tmux new -s hack
#     fi
#   fi
# fi


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
  # cd "$target" && zle && zle reset-prompt || return 1
  
  # Generate a unique session name (could be based on timestamp or directory)
  session_name="fzf-$(basename "$target")"
  if tmux has-session -t "$session_name" 2>/dev/null; then
    exec </dev/tty
    exec <&1
    tmux attach -t "$session_name"
  else 
    exec </dev/tty
    exec <&1
    tmux new-session -s "$session_name" -c "$target"
  fi

  # Attach to the newly created tmux session
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



# Function to attach or create a tmux session
attach_or_create_tmux_session() {
  target_directory="~/Dev"

  if which tmux 2>&1 >/dev/null; then
    # Ensure that tmux is run in a proper TTY
    # We use `tty` to determine the terminal, and if it's not a proper terminal, restore it
    if [[ -z "$TTY" ]] || ! tty -s; then
      export TTY=$(tty)
    fi

    # Check if we are not already inside a tmux session
    if [ "$TERM" != "screen-256color" ] && [ "$TERM" != "screen" ]; then
      # Check if the tmux session "hack" exists
      if tmux has-session -t hack 2>/dev/null; then
        # If it exists, attach to it
        exec </dev/tty
        exec <&1
        tmux attach -t hack
      else
        # If it doesn't exist, create it and start in the target directory
        exec </dev/tty
        exec <&1
        tmux new-session -s hack -c "$target_directory"
      fi
    fi
  fi
}

# Create a widget out of the function (to be callable by keybinding)
zle -N attach_or_create_tmux_session

# Bind the function to the keybinding Ctrl+t
bindkey '^t' attach_or_create_tmux_session



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

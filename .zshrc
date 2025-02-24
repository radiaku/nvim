# mv ~/.zshrc ~/.config/nvim/zshrc
# ln -s ~/.config/nvim/.zshrc ~/.zshrc
#
# curl -sSL https://github.com/zthxxx/jovial/raw/master/installer.sh | sudo -E bash -s ${USER:=whoami}
# brew install zsh-autocomplete
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
# or use source ~/.config/nvim/zshrc_mac

# export TERM='xterm-256color'
export TERM="xterm-256color"
# export TERMINAL="alacritty"


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="jovial"

plugins=(
  git
  zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh


# function set_editor() {
#     if command -v vimx &> /dev/null; then
#         export EDITOR='vimx'
#         export VISUAL='vimx'
#     elif command -v vim &> /dev/null; then
#         export EDITOR='vim'
#         export VISUAL='vim'
#     else
#         export EDITOR='vi'
#         export VISUAL='vi'
#     fi
# }
#
# set_editor

# function vim() {
#     if command -v vimx &> /dev/null; then
#         vimx "$@"
#     elif command -v vim &> /dev/null; then
#         vim "$@"
#     else
#         vi "$@"
#     fi
# }

unalias manage_tmux_session 2>/dev/null
manage_tmux_session() {
  # Access the session name and target directly using positional parameters
  exec </dev/tty
  exec <&1

  if [ -z "$TMUX" ]; then
    # echo "not inside tmux"
    # Not inside tmux: Create or attach to a session
    # if tmux has-session -t "$1" 2>/dev/null; then
    if tmux ls | grep -q "^$1:"; then
      # echo "not inside tmux has session attach it $1"
      tmux attach -t "$1"
    else
      tmux new-session -s "$1" -c "$2"
    fi
  else
    # Inside tmux: Create or switch to the session
    # echo "inside tmux"
    # if tmux has-session -t "$1" 2>/dev/null; then
    if tmux ls | grep -q "^$1:"; then
      # echo "inside tmux has session attach it $1"
      tmux switch-client -t "$1"
      # tmux attach -dt "$1"
    else 
      # tmux new-session -A -s "$1"
      tmux new-session -ds "$1" -c "$2"
      tmux switch-client -t "$1"
    fi
  fi
}

# Remove any existing alias
unalias fzf-cd 2>/dev/null

fzf-cd() {
  [ -n "$ZLE_STATE" ] && trap 'zle reset-prompt' EXIT
  local fd_options fzf_options target

  fd_options=(
    --type directory
    --max-depth 2
    --exclude .git
    --exclude node_modules
  )

  fzf_options=(
    --preview='tree -L 1 {}'
    --bind=ctrl-space:toggle-preview
    --exit-0
  )

  target="$(fd . ~/Dev "${fd_options[@]}" | fzf "${fzf_options[@]}")"

  if [[ -z "$target" ]]; then
    zle reset-prompt
    return
  fi

  test -f "$target" && target="${target%/*}"

  session_name="fzf-$(basename "$target")"

  # Print the session name for testing
  # echo "Session Name: $session_name"
  # echo "TMUX : $TMUX"

  # Call the new function to manage tmux session
  manage_tmux_session "$session_name" "$target"

  # Reset the prompt after exiting the tmux session
  zle reset-prompt
}

# Create a zsh widget
zle -N fzf-cd
bindkey '^F' fzf-cd


unalias fzf_personal 2>/dev/null
fzf_personal() {
  [ -n "$ZLE_STATE" ] && trap 'zle reset-prompt' EXIT
  local fd_options fzf_options target

  fd_options=(
    --type directory
    --max-depth 2
    --exclude .git
    --exclude node_modules
    --exclude work
  )

  fzf_options=(
    --preview='tree -L 1 {}'
    --bind=ctrl-space:toggle-preview
    --exit-0
  )

  target="$(fd . ~/Dev "${fd_options[@]}" | fzf "${fzf_options[@]}")"

  if [[ -z "$target" ]]; then
    # echo "No directory selected, exiting." 
    zle reset-prompt
    return
  fi

  test -f "$target" && target="${target%/*}"

  session_name="fzf-$(basename "$target")"

  # Call the new function to manage tmux session
  manage_tmux_session "$session_name" "$target"

  # Reset the prompt after exiting the tmux session
  zle reset-prompt
}

# Create a zsh widget
zle -N fzf_personal
bindkey '^P' fzf_personal


function ff() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}



# Function to enter alternate screen mode and clear the screen
function ias() {
    echo -e "\033[?1049h"
    clear
    printf '\e[3J'
}

# Function to exit alternate screen mode, clear the screen, and attempt to clear the scrollback buffer
function cas() {
    echo -e "\033[?1049l"
    clear
    printf '\e[3J'
}


# History
#
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history

eval "$(zoxide init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"


# mv ~/.zshrc ~/.config/nvim/zshrc
# ln -s ~/.config/nvim/.zshrc ~/.zshrc
# ln -s "$HOME/.config/nvim/.zshrc.d" "$HOME/.zshrc.d"


# curl -sSL https://github.com/zthxxx/jovial/raw/master/installer.sh | sudo -E bash -s ${USER:=whoami}
# brew install zsh-autocomplete
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
# sudo scutil --set HostName macbookpro
# or use source ~/.config/nvim/zshrc_mac
# sudo ln --symbolic $(which fdfind) /usr/local/bin/fd

# export TERM='xterm-256color'
export TERM="xterm-256color"
export EDITOR='vim'
export VISUAL='vim'

alias nv='nvim'
alias v='vim'
alias py3='python3'

# Function to sanitize session names
sanitize_session_name() {
  local trimmed="$(echo -n "$1" | xargs)"
  local cleaned="$(echo -n "$trimmed" | tr -c '[:alnum:]_.-' '_')"
  echo "${cleaned%"_"}"
}


manage_tmux_session() {
  exec </dev/tty
  exec <&1

  if [ -z "$TMUX" ]; then
    if tmux ls | grep -q "^$1:"; then
      tmux attach -t "$1"
    else
      tmux new-session -s "$1" -c "$2"
    fi
  else
    if tmux ls | grep -q "^$1:"; then
      tmux switch-client -t "$1"
    else 
      tmux new-session -ds "$1" -c "$2"
      tmux switch-client -t "$1"
    fi
  fi
}

# manage_tmux_session() {
#   local session_name="$1"
#   local target_dir="$2"
#
#   # Fall back to home if no directory passed
#   [ -z "$target_dir" ] && target_dir="$HOME"
#
#   exec </dev/tty
#   exec <&1
#
#   if [ -z "$TMUX" ]; then
#     if tmux has-session -t "$session_name" 2>/dev/null; then
#       tmux attach -t "$session_name"
#     else
#       (cd "$target_dir" && tmux new-session -s "$session_name")
#     fi
#   else
#     if tmux has-session -t "$session_name" 2>/dev/null; then
#       tmux switch-client -t "$session_name"
#     else
#       (cd "$target_dir" && tmux new-session -ds "$session_name")
#       tmux switch-client -t "$session_name"
#     fi
#   fi
# }

# Function to manage tmux sessions
# manage_tmux_session() {
#   exec </dev/tty
#   exec <&1
#
#   if [ -z "$TMUX" ]; then
#     if tmux ls | grep -q "^$1:"; then
#       tmux attach -t "$1"
#     else
#       tmux new-session -s "$1"
#       tmux send-keys "cd $2" C-m  # Change directory after creating the session
#     fi
#   else
#     if tmux ls | grep -q "^$1:"; then
#       tmux switch-client -t "$1"
#     else 
#       tmux new-session -ds "$1"
#       tmux send-keys "cd $2" C-m  # Change directory after creating the session
#       tmux switch-client -t "$1"
#     fi
#   fi
# }

# Remove any existing alias
unalias fzf-cd 2>/dev/null

# Function to change directories using fzf and manage tmux sessions
fzf-cd() {
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

  # Check if the Escape key was pressed (target will be empty)
  if [[ -z "$target" ]]; then
    return 0  # Do nothing if Escape was pressed
  fi

  test -f "$target" && target="${target%/*}"

  parent_dir="$(basename "$(dirname "$target")")"
  prefix="${parent_dir:0:1}"  # First letter
  basename="$(basename "$target")"
  session_name="fzf-${prefix}_${basename}"
  session_name="$(sanitize_session_name "$session_name")"

  manage_tmux_session "$session_name" "$target" || {
    echo "Failed to create or attach to tmux session."
    return 1
  }
}


# Bind Ctrl+F to execute fzf-cd
bind -x '"\C-f": fzf-cd'

function jump_to_tmux_session() {
  if [ -z "$TMUX" ]; then
    local selected_session
    selected_session=$(tmux list-sessions -F '#{session_name}' | \
      sort -r | \
      fzf --reverse --header "Jump to session" \
          --preview 'tmux capture-pane -t {} -p | head -20' \
          --bind 'ctrl-d:execute-silent(tmux kill-session -t {})+reload(tmux list-sessions -F "#{session_name}" | sort -r)')

    if [ -n "$selected_session" ]; then
      manage_tmux_session "$selected_session" || {
        echo "Failed to attach to tmux session."
        return 1
      }
    else
      echo "No session selected."
    fi
  else
    tmux list-sessions -F '#{session_name}' | \
      sort -r | \
      fzf --reverse --header "Jump to session" \
          --preview 'tmux capture-pane -pt {} | head -20' \
          --bind 'ctrl-d:execute-silent(tmux kill-session -t {})+reload(tmux list-sessions -F "#{session_name}" | sort -r)' | \
      xargs -r tmux switch-client -t
  fi
}


# Bind Alt+l to the function
bind -x '"\C-L": jump_to_tmux_session'



# ff() {
#     aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
# }
# bind -x '"\C-A": ff'

# Function to enter alternate screen mode and clear the screen
ias() {
    echo -e "\033[?1049h"
    clear
    printf '\e[3J'
}

# Function to exit alternate screen mode, clear the screen, and attempt to clear the scrollback buffer
cas() {
    echo -e "\033[?1049l"
    clear
    printf '\e[3J'
}


export PATH=~/.local/bin/:$PATH
eval "$(rbenv init - --no-rehash zsh)"

export PATH=$PATH:$HOME/go/bin
eval "$(zoxide init zsh)"


# Load system-wide bash completion
if [ -f /etc/profile.d/bash_completion.sh ]; then
    source /etc/profile.d/bash_completion.sh
fi

# Enable history search with up/down arrows (only if commented out above)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Load fzf keybindings (for fuzzy history search with Ctrl+R, Ctrl+T, etc.)
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi



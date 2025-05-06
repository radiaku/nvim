# mv ~/.zshrc ~/.config/nvim/zshrc
# ln -s ~/.config/nvim/.zshrc ~/.zshrc
# ln -s "$HOME/.config/nvim/.zshrc.d" "$HOME/.zshrc.d"


# curl -sSL https://github.com/zthxxx/jovial/raw/master/installer.sh | sudo -E bash -s ${USER:=whoami}
# brew install zsh-autocomplete
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
# sudo scutil --set HostName macbookpro
# or use source ~/.config/nvim/zshrc_mac
# sudo ln --symbolic $(which fdfind) /usr/local/bin/fd

case $- in
    *i*) ;;
      *) return;;
esac

export LC_TIME="en_US.UTF-8"
export DATE_FORMAT="%Y %m %d %H:%M:%S"

HISTSIZE=10000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize


# export TERM='xterm-256color'
export TERM="xterm-256color"
export EDITOR='vim'
export VISUAL='vim'

# make cursor on below
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

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
      tmux new-session -ds "$1"  # Create a detached session
      tmux send-keys -t "$1" "cd $2" C-m > /dev/null 2>&1
      tmux attach -t "$1"  # Attach the session
    fi
  else
    if tmux ls | grep -q "^$1:"; then
      tmux switch-client -t "$1"
    else
      tmux new-session -ds "$1"
      tmux send-keys -t "$1" "cd $2" C-m > /dev/null 2>&1
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

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

eval "$(zoxide init bash)"

export PATH="$HOME/miniconda3/bin:$PATH"
source "$HOME/miniconda3/etc/profile.d/conda.sh"

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

# Ensure only one ssh-agent is running and set the correct environment variables
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null
    eval $(keychain --eval --quiet --agents ssh id_ed25519_global)
    # eval $(keychain --eval --agents ssh id_ed25519_global) > /dev/null
else
    # Check if ssh-agent is running and set SSH_AUTH_SOCK
    if pgrep -u "$USER" ssh-agent > /dev/null; then
        # export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*" -exec echo {} \; | head -n 1)
        export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*" -print -quit)
        export SSH_AGENT_PID=$(pgrep -u "$USER" -a ssh-agent | awk '{print $1}' | head -n 1)
    fi
    if ! ssh-add -l > /dev/null 2>&1; then
        ssh-add "$HOME/.ssh/id_ed25519_global" > /dev/null
    fi
fi

# Export variables for future sessions
export SSH_AUTH_SOCK
export SSH_AGENT_PID

# # Load fzf keybindings (for fuzzy history search with Ctrl+R, Ctrl+T, etc.)
# if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
#     source /usr/share/doc/fzf/examples/key-bindings.bash
# else 
#     source $HOME/.fzf-keybinding.bash
#
# fi
#
# __fzf_history_search() {
#     local query="${READLINE_LINE}"
#     local selected
#     selected=$(history | fzf --tac +s --tiebreak=index --ansi --no-sort --reverse \
#         --prompt='History> ' --query="$query" | sed 's/ *[0-9]* *//')
#     if [ -n "$selected" ]; then
#         READLINE_LINE="$selected"
#         READLINE_POINT=${#READLINE_LINE}
#     fi
# }
#
# bind -x '"\C-r": __fzf_history_search'   


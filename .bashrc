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

# export LC_TIME="en_US.UTF-8"
# export DATE_FORMAT="%Y %m %d %H:%M:%S"

HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize

# export TERM='xterm-256color'
export TERM="xterm-256color"
export EDITOR='vim'
export VISUAL='vim'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt


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

# Enable fast directory jumping via zoxide (z/zi) when available
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# Function to sanitize session names
sanitize_session_name() {
  local input="$1"
  # Trim leading/trailing whitespace using parameter expansion
  input="${input#"${input%%[![:space:]]*}"}"
  input="${input%"${input##*[![:space:]]}"}"
  # Replace non-alphanumeric with _
  local cleaned
  cleaned="$(echo -n "$input" | tr -c '[:alnum:]' '_')"
  # Remove trailing underscore if present
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
      tmux send-keys -t "$1" "clear" C-m
      tmux attach -t "$1"  # Attach the session
    fi
  else
    if tmux ls | grep -q "^$1:"; then
      tmux switch-client -t "$1"
    else
      tmux new-session -ds "$1"
      tmux send-keys -t "$1" "cd $2" C-m > /dev/null 2>&1
      tmux send-keys -t "$1" "clear" C-m
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

  # Helper to shorten path: keep last 2 dirs, prefix earlier with first letters
  shorten_path() {
    local path="$1"
    local IFS='/'
    read -ra parts <<< "$path"
    local out=""
    local n=${#parts[@]}
    for i in "${!parts[@]}"; do
      local seg="${parts[i]}"
      if [ -z "$seg" ]; then
        out+="/"
        continue
      fi
      if (( i < n-2 )); then
        out+="${seg:0:1}/"
      else
        out+="$seg/"
      fi
    done
    echo "${out%/}"
  }

  fd_options=(
    --type directory
    --max-depth 2
    --exclude .git
    --exclude node_modules
  )

  fzf_options=(
    --preview='tree -L 1 {2}'
    --bind=ctrl-space:toggle-preview
    --exit-0
    --delimiter=$'\t'
    --with-nth=1
    --nth=1
  )

  target="$(
    fd . ~/Dev "${fd_options[@]}" |
    while IFS= read -r p; do printf '%s\t%s\n' "$(shorten_path "$p")" "$p"; done |
    fzf "${fzf_options[@]}" | awk -F '\t' '{print $NF}'
  )"

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
      fzf --reverse --cycle --header "Jump to session" \
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
      fzf --reverse --cycle --header "Jump to session" \
          --preview 'tmux capture-pane -pt {} | head -20' \
          --bind 'ctrl-d:execute-silent(tmux kill-session -t {})+reload(tmux list-sessions -F "#{session_name}" | sort -r)' | \
      xargs -r -I {} tmux switch-client -t "{}"
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
# Initialize rbenv only if installed
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# Initialize zoxide only if installed (avoid errors when absent)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi


# Initialize Miniconda if installed (avoids errors when absent)
if [ -d "$HOME/miniconda3" ]; then
  export PATH="$HOME/miniconda3/bin:$PATH"
  if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/miniconda3/etc/profile.d/conda.sh"
  fi
fi
# If conda is present, also source its profile (guarded)
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
  . "$HOME/miniconda3/etc/profile.d/conda.sh"
fi

# Load system-wide bash completion
if [ -f /etc/profile.d/bash_completion.sh ]; then
    source /etc/profile.d/bash_completion.sh
fi

# Enable history search with up/down arrows (only if commented out above)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# # Ensure only one ssh-agent is running and set the correct environment variables
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     eval "$(ssh-agent -s)" > /dev/null
#     eval $(keychain --eval --quiet --agents ssh id_ed25519_global)
#     # eval $(keychain --eval --agents ssh id_ed25519_global) > /dev/null
# else
#     # Check if ssh-agent is running and set SSH_AUTH_SOCK
#     if pgrep -u "$USER" ssh-agent > /dev/null; then
#         # export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*" -exec echo {} \; | head -n 1)
#         export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*" -print -quit)
#         export SSH_AGENT_PID=$(pgrep -u "$USER" -a ssh-agent | awk '{print $1}' | head -n 1)
#     fi
#     if ! ssh-add -l > /dev/null 2>&1; then
#         ssh-add "$HOME/.ssh/id_ed25519_global" > /dev/null
#     fi
# fi
#
# # Export variables for future sessions
# export SSH_AUTH_SOCK
# export SSH_AGENT_PID


# ==== SSH agent bootstrap ====
# Reuse an existing agent if possible
if [ -z "$SSH_AUTH_SOCK" ] && [ -f "$HOME/.ssh/agent.env" ]; then
  . "$HOME/.ssh/agent.env" >/dev/null 2>&1
  # drop stale env if agent died
  ssh-add -l >/dev/null 2>&1 || rm -f "$HOME/.ssh/agent.env"
fi

# Start a new agent if needed
if ! ssh-add -l >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null
  echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$HOME/.ssh/agent.env"
  echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$HOME/.ssh/agent.env"
  # try to add your default key (skip if it doesn't exist)
  [ -f "$HOME/.ssh/id_ed25519" ] && ssh-add "$HOME/.ssh/id_ed25519"
  clear
fi
# ==== end SSH agent bootstrap ====

# Load fzf keybindings (for fuzzy history search with Ctrl+R, Ctrl+T, etc.)
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
elif [ -f "$HOME/.fzf-keybinding.bash" ]; then
    source "$HOME/.fzf-keybinding.bash"
fi
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
#

parse_git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo " (git:$branch)"
    fi
}

current_time() {
    echo "($(date +"%d/%b/%Y %H:%M:%S"))"
}

# Update PS1 to include git branch
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]$(current_time)\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch) | $(current_time)\n\$ '
fi


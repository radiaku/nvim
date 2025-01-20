# mv ~/.zshrc ~/.config/nvim/zshrc
# ln -s ~/.config/nvim/.zshrc ~/.zshrc
#
# curl -sSL https://github.com/zthxxx/jovial/raw/master/installer.sh | sudo -E bash -s ${USER:=whoami}
# brew install zsh-autocomplete
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
# sudo scutil --set HostName macbookpro
# or use source ~/.config/nvim/zshrc_mac

# export TERM='xterm-256color'
export TERM="xterm-256color"
export EDITOR='nvim'
export VISUAL='nvim'

eval "$(/usr/local/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="jovial"

plugins=(
  git
  zsh-autocomplete
  jovial
  z
)


source $ZSH/oh-my-zsh.sh


# Remove any existing alias
unalias fzf-cd 2>/dev/null

# alias fzf-cd="cd ~ && cd \$(find ~/Dev --max-depth 2 -type d \( -name node_modules -o -name .git \) -prune -o -name '*'  -type d -print | fzf)"
#
# Define the fzf-cd function to search only for directories in ~/Dev, skipping node_modules and .git, limited to 2 levels deep
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
    # echo "No directory selected, exiting." 
    zle reset-prompt
    return
  fi

  test -f "$target" && target="${target%/*}"

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
}

# Create a zsh widget
zle -N fzf-cd
bindkey '^F' fzf-cd


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


# History
#
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history



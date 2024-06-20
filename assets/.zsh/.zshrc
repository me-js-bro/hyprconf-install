# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
source ~/.zsh/alias
source ~/.zsh/functions

# Show the runtime
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export RPROMPT="%F{cyan}${timer_show}s %{$reset_color%}"
    unset timer
  fi
}

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"

# case sensetivity
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

zstyle ':omz:update' mode reminder	# just remind me to update when it's time

plugins=(
    git
    zsh-autosuggestions
    jsontools
    web-search
	  themes
    zsh-syntax-highlighting
    )

source $ZSH/oh-my-zsh.sh

# neofetch
fastfetch

# Set zsh as default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)"
fi

# Install Zinit if missing
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  echo "Installing Zinit..."
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Oh My Zsh core
export ZSH="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_THEME="robbyrussell"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Homebrew on macOS
if command -v brew &> /dev/null; then
  eval "$(brew shellenv)"
fi

# Auto-install fzf
if ! command -v fzf &> /dev/null; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --no-update-rc
fi

# Enable completions and plugins
autoload -Uz compinit && compinit
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History configuration
enable_automatic_hist_save() {
  setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups
}
enable_automatic_hist_save
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias cl='clear'
alias b='cd -'
alias ll='eza --color=always --long --git --icons=always --no-user --no-permissions --group-directories-first -a'
alias la='ls -la'
alias l='ls -lAh'
alias cat='bat'
alias g='git'
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias rm='rm -i'
alias update='sudo apt update && sudo apt upgrade'
alias please='sudo'
alias py='python3'
alias grep='grep --color=auto'

# Bun (if used)
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Custom functions
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Set PATH ordering
export PATH="$HOME/.cargo/bin:$HOME/bin:/opt/homebrew/bin:$PATH"

# Default editor
export EDITOR='nvim'

# Local overrides
[ -f ~/.zshrc.local ] && source ~/.zshrc.local


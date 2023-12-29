# Enjoy the silence
unsetopt BEEP

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="fwalch"

# change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

# change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# change the command execution time
# stamp shown in the history command output.
HIST_STAMPS="dd/mm/yyyy"

# Which plugins would you like to load?
plugins=(git fzf-tab zsh-autosuggestions zsh-syntax-highlighting)

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor
export EDITOR='hx'

# zstyle ':completion:*' rehash true

# source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# sbin for homebrew
export PATH="/usr/local/sbin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export FZF_THEME_CATPPUCCIN_LATTE=" \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

export FZF_THEME_CATPPUCCIN_FRAPPE=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

export FZF_THEME_CATPPUCCIN_MACCHIATO=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

export FZF_THEME_CATPPUCCIN_MOCHA=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_THEME_PAPERCOLOR_LIGHT=" \
--color=fg:#1c1c1c,bg:#eeeeee,hl:#ff5faf \
--color=fg+:#1c1c1c,bg+:#d0d0d0,hl+:#ff5faf \
--color=info:#d70087,prompt:#d70087,pointer:#d70087 \
--color=marker:#8700af,spinner:#d70087,header:#8700af \
--color=gutter:-1"

export FZF_THEME_PAPERCOLOR_LIGHT=" \
--color=fg:#1c1c1c,bg:#eeeeee,hl:#ff5faf \
--color=fg+:#1c1c1c,bg+:#d0d0d0,hl+:#ff5faf \
--color=info:#d70087,prompt:#d70087,pointer:#d70087 \
--color=marker:#8700af,spinner:#d70087,header:#8700af \
--color=gutter:-1"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
  --ansi \
  --color=16 \
  --height 75% \
  --border bold \
  --layout reverse \
  --prompt '∷ ' \
  --pointer ▶ \
  --marker  \
  --margin 1 \
  --padding 1"

alias ls="exa -a --icons --color=always --group-directories-first"
alias cat="bat --theme ansi"

export HOMEBREW_NO_INSTALL_CLEANUP=1

eval "$(zoxide init zsh)"
alias cd="z"

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

export PATH="$HOME/bin:$PATH"

export PATH="/usr/local/opt/llvm/bin:$PATH"

eval "$(pyenv virtualenv-init -)"

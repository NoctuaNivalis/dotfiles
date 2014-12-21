
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/felix/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Get ourselves a nice prompt.
git_status() {
    if git status 2>/dev/null 1>&2; then
        git branch | grep \*
        git status --porcelain | cat <(echo OK) - | sed 's/\(..\).*/(\1)/' | tail -1
    fi
}
autoload -U colors && colors
export PS1="[%*] %{$fg[red]%}%n@%m%{$reset_color%} %{$fg_bold[green]%}%~%{$reset_color%} "'$(git_status | xargs echo)'"
 %(?.$.%%) "; setopt promptsubst

# Color ls
alias ls="ls --color=auto"

# Local scripts
export PATH="$HOME/.local/bin":"$PATH"

# Cabal
#export PATH="$HOME/.cabal/bin":"$PATH"

# Gems
export PATH="$(ruby -rubygems -e "puts Gem.user_dir")/bin":"$PATH"
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"

# For vim
export EDITOR="vim"
stty -ixon # turn of <C-s> for vimshell

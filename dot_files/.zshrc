export PATH="$HOME/.tfenv/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Set up autocompletion on zsh shells - should work for git branches as well: https://www.macinstruct.com/tutorials/how-to-enable-git-tab-autocomplete-on-your-mac/
autoload -Uz compinit && compinit

export GIT_EDITOR=emacs

#============================================================
# For managing Rbenv

source $HOME/.zshenv
# Local custom snippets
for item in $(ls -1 ${HOME}/.profile.d/*.plugin.zsh); do
  [ -e "${item}" ] && source "${item}"
done

# End
#============================================================

# Created by `userpath` on 2021-02-05 23:39:04
export PATH="$PATH:/Users/georgeholt/.local/bin"

# Created by `userpath` on 2021-02-05 23:39:05
export PATH="$PATH:/Users/georgeholt/Library/Python/3.9/bin"

if [ -d /opt/chef-workstation ]; then
    export PATH="$PATH:/Users/georgeholt/.chefdk/gem/ruby/2.7.0/bin:/opt/chef-workstation/bin:/opt/chef-workstation/embedded/bin"

    #eval "$(chef shell-init zsh)"
fi

alias lm='ls -al |more'
alias gfa='git fetch --all'
alias gpfo='git pull --ff-only'
alias gammend='git add .; git commit --amend; git push -f'
alias history='history 200'

alias grep='grep --exclude-dir .mypy_cache --color=always'

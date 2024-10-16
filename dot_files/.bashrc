# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

alias lm='ls -al |more'

if [ -d /opt/chef-workstation ]; then
    export PATH="/opt/chef-workstation/bin:/opt/chef-workstation/embedded/bin:$PATH"

    eval "$(chef shell-init bash)"

    # Use the tools in the chef-workstation vs the system
    export PATH="${PATH}:/Users/georgeholt/.chefdk/gem/ruby/2.7.0/bin"
fi



# This is a new one, except for the time.
#ZSH_THEME="tjkirch"
# Creates a shorter path, but still nice.
#ZSH_THEME="risto"
# Bart is a mix of risto and tjkirch
ZSH_THEME="bart"
CASE_SENSITIVE="false"
plugins=(git debian extract ssh-agent tmux)

# Load the bash aliases I already had.
if [[ -f $HOME/.shell_aliases ]] ; then
  source $HOME/.shell_aliases
fi
if [[ -f $HOME/.work_aliases ]] ; then
  source $HOME/.work_aliases
fi
if [[ -f $HOME/.shell_env ]] ; then
  source $HOME/.shell_env
fi
if [[ -f $HOME/.bash_env ]] ; then
  source $HOME/.bash_env
fi
if [[ $(id -u) == 0 ]]; then
	if [[ -f $HOME/.root_aliases ]] ; then
	  source $HOME/.root_aliases
	fi
fi

### Setting additional paths
if [ -d $HOME/bin ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d $HOME/.local/bin ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
# set PATH so it includes user's private scripts if it exists
if [ -d $HOME/scripts ] ; then
    PATH="$HOME/scripts:$PATH"
fi

# loading fasd separately to get it working
if [[ -f $HOME/.oh-my-zsh/plugins/fasd/fasd.plugin.zsh ]] ; then
  source $HOME/.oh-my-zsh/plugins/fasd/fasd.plugin.zsh
fi

# ssh-agent settings
zstyle :omz:plugins:ssh-agent agent-forwarding off
zstyle :omz:plugins:ssh-agent identities id_rsa
zstyle :omz:plugins:ssh-agent lifetime 300

# TMUX settings
export DISABLE_AUTO_TITLE='true'

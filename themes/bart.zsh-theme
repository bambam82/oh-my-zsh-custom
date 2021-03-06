# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

autoload -U colors && colors

setopt PROMPT_SUBST

function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}
function user_color {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}"; else echo "%{$fg[magenta]%}"; fi
}

set_prompt() {

	# Providing the user and the machine, using a color diff between user and root
	# PS1="%_$(user_color)%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}"
	# Only using the system name, since user is usually the same.
	PS1="%_$(user_color)%m%{$reset_color%} "

	# Path: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
	PS1+="%{$fg_bold[blue]%}%2~%{$reset_color%}"

	# Status Code
	PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

	# Git
	if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
		PS1+=', '
		PS1+="%{$fg[blue]%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
		if [ $(git status --short | wc -l) -gt 0 ]; then 
			PS1+="%{$fg[red]%}+$(git status --short | wc -l | awk '{$1=$1};1')%{$reset_color%}"
		fi
	fi

	# virtualenv
	if [[ -n "$(whence virtualenv_prompt_info)" ]]; then
		if [[ "$(virtualenv_prompt_info)" ]]; then
			PS1+=", "
			PS1+="%{$fg[yellow]%}venv:‹%{$fg[cyan]%}$(basename $VIRTUAL_ENV)%{$fg[yellow]%}›%{$reset_color%}"
		fi
	fi

	# Pyenv prompt
	if [[ -n "$(whence pyenv_prompt_info)" ]]; then
		if [[ "$(pyenv_prompt_info)" ]]; then
			PS1+=", "
			PS1+="%{$fg[yellow]%}py:‹%{$fg[cyan]%}$(pyenv_prompt_info)%{$fg[yellow]%}›%{$reset_color%}"
		fi
	fi

	# Timer: http://stackoverflow.com/questions/2704635/is-there-a-way-to-find-the-running-time-of-the-last-executed-command-in-the-shel
	if [[ $_elapsed[-1] -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
	fi

	# PID
	if [[ $! -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
	fi

	# PS1+="%{$fg[white]%}]: %{$reset_color%}% "
	PS1+=" %_$(prompt_char) "
}

precmd_functions+=set_prompt

preexec () {
   (( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
   _start=$SECONDS
}

precmd () {
   (( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
   _start=-1 
}

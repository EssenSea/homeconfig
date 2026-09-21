#!/etc/skel/.bash_profile
export GPG_TTY=$(tty)
eval "$(ssh-agent -s)"

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
stty -ixon
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

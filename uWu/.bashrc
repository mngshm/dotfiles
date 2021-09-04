#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='logo-ls'
alias la='logo-ls -A'
alias ll='logo-ls -al'
# equivalents with Git Status on by Default
alias lsg='logo-ls -D'
alias lag='logo-ls -AD'
alias llg='logo-ls -alD'
alias xw='xwallpaper --zoom' 
alias orphan='pacman -Qtdq | pacman -Rns -'
source ~/.bash-powerline.sh


#PS1='\033\e[0;31m󰅂\033\e[0m\e[0;32m󰅂\e[0;34m󰅂\e[0m \e[1;36m󰉋 \e[0m \W '
rxfetch

if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi 


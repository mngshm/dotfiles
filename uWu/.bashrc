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
source ~/.bash-powerline.sh

alias load="kill -USR1 $(pidof st)"
alias  use="xrdb merge"


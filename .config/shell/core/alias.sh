#!/usr/bin/env bash

alias ls="ls -a --group-directories-first --color=always"
alias ll="ls -la --group-directories-first --color=always"

# Autojump
j() {
	cd "$2/$1" || echo "Directory not found."
}

# Repository List
repos() {
	j "$(exa -l /storage/projects/repos | awk '{print $7}' | fzf)" "/storage/projects/repos"
}

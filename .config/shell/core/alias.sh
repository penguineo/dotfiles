alias ll='ls -lah --group-directories-first --color=always'
alias gg='bcd $(ls | fzf)'
alias gr='cd /storage/projects/repos/$(ls /storage/projects/repos | fzf)'
alias gc='bcd $CONFIG/$(ls $CONFIG | fzf)'
alias gs='bcd $STORAGE/$(ls $STORAGE | fzf)'

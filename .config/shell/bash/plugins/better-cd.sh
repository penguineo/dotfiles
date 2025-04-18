bcd(){
	query="$1"
	[ -d "$query" ] && cd $query
	[ -f "$query" ] && nvim $query
}

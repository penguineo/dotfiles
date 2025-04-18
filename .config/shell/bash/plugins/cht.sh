cht(){
	query=$(curl cht.sh/:list | fzf)
	query_list=$(curl cht.sh/$query/:list | fzf)
	curl cht.sh/$query/:learn/$query_list
}

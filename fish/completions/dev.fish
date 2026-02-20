# completion script for dev function that cd to ~/Dev/<project>/...
# expands subdirs recursively


function __fish_dev_generate_subdirs --description "list sub-directories under ~/Dev"
	# use find to get every directory, strip leading ~/Dev/,
	# replaces slashes '/' for display and keep only real dirs?
	set -l base (string replace -r '^~/' '$HOME/') ~/Dev

	if test ! -d $base
		return 0 # nothing to complete if the folder does not exist
	end

	find "$base" -mindepth 1 -maxdepth 3 -type d \
	| string replace -r "$HOME/Dev" "" \
	| string trim -c "/"  # remove trailing '/'
end

# definition
complete -c dev \
	-a "(__fish_dev_generate_subdirs)" \
	-d "sub-directory of ~/Dev" \
	-r
# complete -c dev -a "(basename -a ~/Dev/*/ 2>/dev/null)"

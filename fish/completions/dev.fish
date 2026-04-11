function __fish_dev_complete
    set -l cmd (commandline -opc)
    set -l count (count $cmd)
    set -l base "$HOME/Dev"

    if test $count -eq 1
		find "$base" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" 2>/dev/null
	else if test $count -eq 2
		set -l category $cmd[2]
		if test  -d "$base/$category"
			find "$base/$category" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" 2>/dev/null
		end
    end
end

complete -c dev -f -a "(__fish_dev_complete)"

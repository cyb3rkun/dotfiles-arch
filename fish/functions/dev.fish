function dev --wraps='cd ~/Dev' --description 'alias dev=cd ~/Dev'
	cd ~/Dev 
	if test (count $argv) -gt 0
		cd $argv
	end
end

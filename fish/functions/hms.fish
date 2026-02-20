function hms --wraps='home-manager switch --flake ~/nix#cyb3r' --description 'alias hm-swtch=home-manager switch --flake ~/nix#cyb3r'
	home-manager switch --flake ~/nix#cyb3r $argv
end

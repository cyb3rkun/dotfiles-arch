function dev --wraps='cd ~/Dev' --description 'Jump to Dev projects'
    set -l base "$HOME/Dev"
    
    if test (count $argv) -eq 0
        cd $base
    else
        # This joins all arguments with slashes, e.g., 'rust' 'meth' -> 'rust/meth'
        set -l target (string join "/" $argv)
        cd "$base/$target"
    end
end

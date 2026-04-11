function sah
    if test (count $argv) -eq 0
        return
    else
        ssh-add $argv
    end
end


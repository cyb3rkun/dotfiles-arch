function shs
    # 1. Check if the CURRENT socket actually exists on disk
    if test -S "$SSH_AUTH_SOCK"
        echo "Agent is already running and valid."
        return
    end

    # 2. If the socket is dead, start a new one
    # This regex cleans up the ssh-agent output for Fish
    ssh-agent -c | string replace -r '^setenv (\w+) (.+);' 'set -gx $1 $2' | source

    # 3. Export these as Universal variables so other windows see them
    set -Ux SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    set -Ux SSH_AGENT_PID "$SSH_AGENT_PID"
    
    echo "New agent started: PID $SSH_AGENT_PID"
end

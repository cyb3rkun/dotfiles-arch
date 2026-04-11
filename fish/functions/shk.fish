function shk
    # Check if the PID variable exists OR if the process is actually running
    if set -q SSH_AGENT_PID; or pgrep -u $USER ssh-agent >/dev/null
        
        # 1. Kill the process directly (more reliable than ssh-agent -k in Fish)
        if set -q SSH_AGENT_PID
            kill $SSH_AGENT_PID >/dev/null 2>&1
        else
            pkill -u $USER ssh-agent >/dev/null 2>&1
        end
        
        # 2. Erase the Universal variables (the most important part for Fish)
        set -eU SSH_AUTH_SOCK
        set -eU SSH_AGENT_PID
        
        # 3. Erase local session variables
        set -e SSH_AUTH_SOCK
        set -e SSH_AGENT_PID
        
        echo "SSH Agent stopped and environment cleared."
    else
        echo "No active ssh-agent found to kill."
    end
end

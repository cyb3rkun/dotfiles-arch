function ash
    # Look for the ssh-agent socket in the standard temp directory
    set -l agent_sock (ls /tmp/ssh-*/agent.* 2>/dev/null | head -n 1)

    if test -n "$agent_sock"
        set -gx SSH_AUTH_SOCK $agent_sock
        # Find the PID associated with the agent
        set -gx SSH_AGENT_PID (pgrep -u $USER ssh-agent | head -n 1)
        echo "Attached to existing ssh-agent (PID $SSH_AGENT_PID)"
    else
        echo "No running ssh-agent found."
    end

end

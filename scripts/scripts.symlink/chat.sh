# #!/usr/bin/bash
SESSION=chat
alias tmux="tmux -2"

# if the session is already running, just attach to it.
tmux has-session -t $SESSION
if [ $? -eq 0 ]; then
    echo "Session $SESSION already exists. Attaching."
    sleep 1
    tmux attach -t $SESSION
else
    tmux new-session -d -s $SESSION 'profanity -a google'
    tmux selectp -t $SESSION
    tmux split-window -h 'profanity -a facebook'
    #tmux split-window -v 'profanity -a krz'
    tmux selectp -t 1
    tmux attach -t $SESSION
fi

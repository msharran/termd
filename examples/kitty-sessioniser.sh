#!/usr/bin/env bash

> /tmp/kitty-sessioniser.log

env > /tmp/kitty-sessioniser.log

grepprg=rg
if !command -v "$grepprg" &>/dev/null; then
    echo "Cannot find 'rg', fallback to grep" >&2
    grepprg=grep
fi

list_projects() {
    fd . $HOME -d 1 -t d -H
    fd . $HOME/root -d 1 -t d -H
    fd . $HOME/root/work $HOME/root/play -d 1 -t d -H
    fd . $HOME/root/play/labs $HOME/root/play/codingchallenges.fyi -d 2 -t d -H
}

abbreviate_path() {
    local full_path="$1"
    # Replace home with ~
    local path_with_tilde=$(echo "$full_path" | sed "s|^$HOME|~|")
    # Abbreviate
    echo "$path_with_tilde" | awk -F/ '
    {
        # Handle trailing slash by reducing NF
        if ($NF == "") {
            NF = NF - 1
        }
        for (i=1; i<NF; i++) {
            if (i==1 && $i == "~") {
                printf "~/"
            } else if (i > 1) {
                printf "%s/", substr($i,1,1)
            } else {
                printf "%s/", $i
            }
        }
        print $NF
    }'
}

# Parse optional argument
if [ "$1" ]; then
    # Argument is given
    if [ ! -d "$@" ]; then
        echo "Directory '$@' does not exist."
        exit 1
    fi
    RESULT=$(cd "$@" && pwd)
else
    # No argument is given. Use FZF
    RESULT=$(list_projects | fzf)
    if [ -z "$RESULT" ]; then
        echo "No projects selected"
        exit 1
    fi
fi

echo "Selected project name: $RESULT" >> /tmp/kitty-sessioniser.log

ABBR_PATH=$(abbreviate_path "$RESULT")

echo "Selected session title: $ABBR_PATH" >> /tmp/kitty-sessioniser.log

# Check if kitty window already exists using aerospace
hit=$(aerospace list-windows --monitor all --app-bundle-id net.kovidgoyal.kitty | $grepprg -e "$ABBR_PATH\$")
if [[ -z $hit ]]; then
    # if the abbr path is not in window name, check for the project name. Some programs
    # like gemini-cli follow this pattern
    hit=$(aerospace list-windows --monitor all --app-bundle-id net.kovidgoyal.kitty | $grepprg "$(basename $ABBR_PATH)")
fi
aerospace_window_id=$(echo $hit | head -n 1 | awk '{print $1}')

# If kitty window already exists, focus it
if [[ $? == 0 ]] && [[ -n "$aerospace_window_id" ]]; then
    aerospace focus --window-id $aerospace_window_id
else
    
    # Launch new kitty os-window
    kitty @ launch --type=os-window --cwd "$RESULT" --title "$ABBR_PATH"
fi


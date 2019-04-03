# ~/.bash_profile: executed by the command interpreter for bash login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes https://github.com/ojullien/Shell tools
if [ -d "/opt/oju/Shell/bin" ]; then
    PATH="$PATH:/opt/oju/Shell/bin"
fi

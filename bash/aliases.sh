alias ..="cd .."
alias ...="cd ../.."
alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -lah"
alias l="ls -CF"

if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never --style=plain"
fi

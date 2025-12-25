#!/usr/bin/env bash

# Dependencies: fzf, bat, ripgrep (rg), tmux, git
# Usage: Source this file in your .bashrc or .zshrc
#        source /path/to/fzf_utils.sh

# -----------------------------------------------------------------------------
# 1. GIT: Checkout Branch or Tag
# -----------------------------------------------------------------------------
gco() {
  local tags branches target branch_name
  
  # 1. Get Branches (sorted by last commit)
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  
  # 2. Get Tags
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  
  # 3. FZF Selection
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --height 50% --layout=reverse --border \
        --no-hscroll --no-multi -n 2 \
        --ansi --preview="
          echo 'Branch: {2}';
          echo '-------------------------------------------------'; 
          # Calculate Ahead/Behind (Left=HEAD, Right=Target)
          git rev-list --left-right --count HEAD...{2} 2>/dev/null \
            | awk '{printf \"Status: \033[32mAhead %d\033[m | \033[31mBehind %d\033[m\n\", \$1, \$2}';
          echo;
          # 1. Short Stat (Numbers)
          git diff --shortstat --color=always HEAD..{2}; 
          echo '-------------------------------------------------';
          "
  ) || return

  # 4. Extract Name & Prompt for Checkout
  branch_name=$(echo "$target" | awk '{print $2}')
  
  if [ -n "$branch_name" ]; then
    read -p "Checkout '$branch_name'? [y/N] " -n 1 -r
    echo # Move to new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git checkout "$branch_name"
    fi
  fi
}

# -----------------------------------------------------------------------------
# 2. PROCESS: Kill Process
# -----------------------------------------------------------------------------
fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# -----------------------------------------------------------------------------
# 3. CODE: Ripgrep -> Fzf -> Neovim (at line number)
# -----------------------------------------------------------------------------
rgc() {
  if [ ! "$#" -gt 0 ]; then echo "Usage: fif <search_term>"; return 1; fi
  
  # 1. Search with rg, including line numbers
  # 2. Fzf selection with preview
  # 3. Extract file and line number
  # 4. Open in $EDITOR (defaults to nvim)
  
  local file
  file=$(rg --line-number --no-heading --color=always --smart-case "$1" | \
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window 'right,60%,border-left,+{2}+3/3,~3')
  echo $file
}

# -----------------------------------------------------------------------------
# 4. TMUX: Switch or Attach Session
# -----------------------------------------------------------------------------
tmux-switch() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  
  # 1. Direct switch if argument provided
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  
  # 2. FZF Selection with Preview
  # 'capture-pane -ep -t {}' dumps the colored content of the active pane in session {}
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf \
    --exit-0 \
    --height 40% \
    --layout=reverse \
    --border \
    --ansi \
    --preview 'tmux capture-pane -ep -t {}' \
    --preview-window 'right:65%' \
  ) && tmux $change -t "$session" || echo "No sessions found."
}
# -----------------------------------------------------------------------------
# 5. SYSTEM: View Environment Variables
# -----------------------------------------------------------------------------
fenv() {
  printenv | fzf
}


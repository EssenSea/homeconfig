# ~/.bashrc
# if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
#     dbus-run-session sway --unsupported-gpu
# fi
# Use bash-completion, if available
source /usr/share/bash-completion/completions/fzf
source /usr/share/fzf/key-bindings.bash
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# ssh-add ~/.ssh/auxread 2>/dev/null
# ssh-add ~/.ssh/id_ed25519 2>/dev/null
# eval "$(atuin init bash)"
# eval "$(thefuck --alias)"
export HISTSIZE=100000
export HISTFILESIZE=500000
export HISTTIMEFORMAT="%F %T "

export WLR_BACKEND=headless
export WLR_RENDERER=vulkan
export WLR_NO_HARDWARE_CURSORS=1
export GBM_BACKEND=nvidia-drm
export XWAYLAND_NO_GLAMOR=1
export WLR_RENDERER_ALLOW_SOFTWARE=1
export CLIPBOARD=wayland
# export HYPRLAND_SHARE_WRITABLE=1


export MANWIDTH=80
export MANPAGER="less -R --use-color -Dd+r -Du+b"
# sh is used because MANPAGER cannot use pipes by itself.
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANPAGER="sh -c \"col -b | \
# vim -c 'set ft=man ts=8 nomod norelativenumber nonu nolist' -c 'nnoremap i <nop>' -\""

export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"
export PATH="$HOME/node_modules/.bin/:$PATH"
export PATH="/usr/bin/mu-mh/:$PATH"
export MANPATH="/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH:"
export USER_BASH_COMPLE=~/.config/bash_completions

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PIP_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

export OPENAI_BASE_URL="https://api.deepseek.com/v1"
export OPENAI_API_KEY=$(pass show deepseek)
export DEEPSEEK_API_KEY=$(pass show deepseek)
export GEMINI_API_KEY=$(pass show gemini)
export MINIMAX_API_KEY=$(pass show minimax)
export ANTHROPIC_API_KEY=$(pass show minimax)

# shellcheck shell=bash
# alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ls="lsd"
alias ll="lsd -la"
alias la="lsd -a"
alias c="clear"
alias wget='wget -c '
alias hw='hwinfo --short'
alias mpv='mpv --loop'
alias mv='mv -i'
alias untar='tar -zxvf '
# alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias sioyek='source $HOME/pyvenv/bin/activate && sioyek'
alias sclean='sudo bash -c "eclean-dist -d && eclean-pkg -d"'
# alias ediff='eix-update && eix-diff'
alias less="less -R --use-color -Dd+r -Du+b"

alias bm='STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"\
STEAM_COMPAT_DATA_PATH="$HOME/.local/share/Steam/steamapps/compatdata/2358720"\
WINEPREFIX="$HOME/.local/share/Steam/steamapps/compatdata/2358720/pfx" \
"$HOME/.local/share/Steam/steamapps/common/Proton Hotfix/proton"\
run "$HOME/Downloads/Black Myth Wukong v1.0-v1.0.20 Plus 44 Trainer.exe"'

voc() {
    command fy "$1" | sed -e "2s/+/**/" | tee -a ~/Documents/notes/vocaulary/voc1.org
}
phra() {
    command fy "$1" | sed -e "2s/+/**/" | tee -a ~/Documents/notes/vocaulary/phrase1.org
}

eval "$(pandoc --completion=bash)"


[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$USER_BASH_COMPLE/zoxide" ] && source "$USER_BASH_COMPLE/zoxide"
[ -f "$USER_BASH_COMPLE/niri" ] && source "$USER_BASH_COMPLE/niri"
# [ -f "$USER_BASH_COMPLE/starship" ] && source "$USER_BASH_COMPLE/starship"
[ -f "$USER_BASH_COMPLE/ps1" ] && source "$USER_BASH_COMPLE/ps1"
[ -f "$USER_BASH_COMPLE/opencode" ] && source "$USER_BASH_COMPLE/opencode"

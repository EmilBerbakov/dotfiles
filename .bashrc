#NOTE: For use in Git Bash for Windows NOT WSL or any Linux distro

eval "$(fnm env --use-on-cd --shell bash)"
fnm use 22

eval $(fnm env | sed 1d)
export PATH=$(cygpath $FNM_MULTISHELL_PATH):$PATH

if [[ -f .node-version || -f .nvmrc ]]; then
    fnm use
fi

angular() {
    source <(ng completion script)
}



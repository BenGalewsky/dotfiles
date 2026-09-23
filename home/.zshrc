# If you come from bash you might have to change your $PATH.
# export PATH=/usr/local/opt/ruby/bin:$HOME/bin:/usr/local/bin:~/Library/Python/3.6/bin:$PATH
 export PATH=/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$HOME/Library/Python/3.8/bin:$HOME/.local/bin:$PATH

export JAVA_HOME=$(/usr/libexec/java_home)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="lambda"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

autoload -U compinit
compinit -i

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode ssh-agent history kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Go
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias river="export KUBECONFIG=~/.kube/river"
alias ngt="export KUBECONFIG=~/.kube/ngt"
alias docker-desktop="export KUBECONFIG=~/.kube/config"
alias river-cms="export KUBECONFIG=~/.kube/river-cms"
alias funcx-prod="export KUBECONFIG=~/.kube/funcx-prod"
alias dsrs="export KUBECONFIG=~/.kube/dsrs"
alias funcx-dev="export KUBECONFIG=~/.kube/funcx-dev"
alias river-pondd="export KUBECONFIG=~/.kube/river-pondd"
alias kind-cluster="export KUBECONFIG=~/.kube/kind"
alias software-dev="export KUBECONFIG=~/.kube/radiant-software-dev"
alias software="export KUBECONFIG=~/.kube/radiant-software"
alias clowder="export KUBECONFIG=~/.kube/clowder"
alias cori-dev="export KUBECONFIG=~/.kube/cori-dev"
alias cori-mini="export KUBECONFIG=~/.kube/cori-mini"
alias software-prod="export KUBECONFIG=~/.kube/radiant-software-prod"
alias clowder-prod="export KUBECONFIG=~/.kube/clowder-prod"



# Switch default kube namespace
function set_namespace() {
  kubectl config set-context --current --namespace=$1
}

# Switch namespaces
alias int-uproot="kubectl config set-context --current --namespace=servicex-int-uproot"
alias int-xaod="kubectl config set-context --current --namespace=servicex-int-xaod"

# Kubectl variations
alias kgpw="watch kubectl get pod"
alias kgj="kubectl get job"
alias kdelk="kubectl delete job"
alias kgitcp="kubectl get ingressroutetcp.traefik.io"
alias kgi="kubectl get ingressroute.traefik.io"

# Delete completed pods
alias kdelcompleted='kubectl get pods --field-selector=status.phase=Succeeded -o name | xargs -r kubectl delete'

# Poetry shortcuts
alias pl="poetry lock"

# Extra git shortcuts
alias gstno="git status -uno"

# Lastpass password copiers
alias lpasspypi="lpass show -c --password pypi.org"
alias lpassdocker="lpass show -c --password 4850673105246839844"

# Venv
alias activate="source .venv/bin/activate"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' vi-backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^b' vi-backward-blank-word
bindkey '^f' vi-forward-blank-word

export KEYTIMEOUT=1

eval `ssh-agent`
# Stopped working July 2020
# zstyle :omz:plugins:ssh-agent agent-forwarding on
[ -f ~/.ssh/cloud.key ] && ssh-add ~/.ssh/cloud.key
[ -f ~/.ssh/bengal.pem ] && ssh-add ~/.ssh/bengal.pem

# added by travis gem
[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"
export PATH="/usr/local/sbin:$PATH"

export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"

# Add python version to the path
pypath() { export PATH="$(dirname $(uv python find "${1:-3.10}")):$PATH"; }



[ -f "$HOME/dev/MDF/aws-token-refresh/profile-additions.source_me" ] && source "$HOME/dev/MDF/aws-token-refresh/profile-additions.source_me"

# Ceph S3 context helper (s3ctx, s3ctxs, s3whoami, s3ctx-clear) - see file for setup
[ -f "$HOME/.config/zsh/ceph-s3.zsh" ] && source "$HOME/.config/zsh/ceph-s3.zsh"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"

# >>> otty shell integration >>>
# Added by Otty — toggle in Settings > Shell > Shell Integration.
# Inert unless launched by Otty (it sets $OTTY_SHELL_INTEGRATION).
if [ -n "$OTTY_SHELL_INTEGRATION" ] && [ -r "$OTTY_SHELL_INTEGRATION/otty-integration.zsh" ]; then
  . "$OTTY_SHELL_INTEGRATION/otty-integration.zsh"
fi
# <<< otty shell integration <<<

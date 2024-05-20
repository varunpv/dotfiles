export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export GOPRIVATE=github.com/confluentinc/* 
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# export GOPROXY=https://goproxy.io,direct
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/Users/varunpv/.local/bin/"

eval "$(fzf --zsh)"
alias sd="cd \$(find * -type d | fzf)"
alias v='nvim' # default Neovim config
alias vz='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim
alias vc='NVIM_APPNAME=nvim-nvchad nvim' # NvChad
alias vk='NVIM_APPNAME=nvim-kickstart nvim' # Kickstart
alias va='NVIM_APPNAME=nvim-astrovim nvim' # AstroVim
alias vl='NVIM_APPNAME=nvim-lunarvim nvim' # LunarVim
alias tn='tmux new-session -s' 
alias t='tmux' 

function finalizer() {
   kubectl delete validatingwebhookconfiguration confluent-operator-$1.webhook.platform.confluent.io
   kubectl get all -n $1 --no-headers | awk '{print $1 }' | xargs kubectl -n $1  patch -p '{"metadata":{"finalizers":[]}}' --type=merge
   kubectl get secrets -n $1 --no-headers | awk '{print $1 }' | xargs kubectl -n $1 patch -p '{"metadata":{"finalizers":[]}}' --type=merge secret
   kubectl get configmap -n $1 --no-headers | awk '{print $1 }' | xargs kubectl -n $1 patch -p '{"metadata":{"finalizers":[]}}' --type=merge configmap
   kubectl delete all -n $1 --all
   kubectl delete ns $1
}

function cpSecretUpdate() {
   assume cc-devel-1/nonprod-administrator
   kubectl create secret docker-registry cp-registry --docker-server=368821881613.dkr.ecr.us-west-2.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password --region us-west-2) --docker-email=vpv@confluent.io  --dry-run=client -oyaml | kubectl apply -f -
}

function jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    python3 -mjson.tool <<< "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        exit 0
    fi
  done
}

eval "$(starship init zsh)"

#source ~/zsh-git-prompt/zshrc.sh
#autoload -U colors && colors
# an example prompt
#PROMPT='%B%n%{$fg[yellow]%}%~%{$reset_color%} %b$(git_super_status) %# '
#export CONFLUENT_HOME=/Users/varunpv/confluent-7.3.1
#export MAVEN_OPTS="-Xms3g -Xmx3g" 
#alias cc=/usr/local/bin/confluent

export PATH=$PATH:$CONFLUENT_HOME/bin:$HOME/git/go/1.15.2/pkg/mod/github.com/go-delve/delve@v1.7.1/cmd
#the google cloud sdk

source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# cpd cluster id 
alias kgc="kubectl config get-contexts"
alias kcc="kubectl config current-context"
alias kuc="kubectl config use-context"
alias kns="kubectl config set-context --current --namespace"
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh) # add autocomplete permanently to your zsh shell
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/varunpv/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
alias dotfiles=/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME

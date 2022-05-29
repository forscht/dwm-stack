# Set up the prompt

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.

EDITOR=vim
OPENER=vim

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -v

# History within the shell and save it to ~/.history:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/.go

# NPM Token for accessing sequr private packages on nam
export NPM_TOKEN=""

# Fetch logs from heroku for current git
heroku-logs(){
    if [ -z ${1+x} ]; then echo "Please provide env dev/dev2/stage. Example: heroku-logs dev"; return; fi
    # Define git remote
    REMOTE=$(echo ${1}-heroku)
    # Define Heroku app name
    APP=$(git remote -v | grep ${REMOTE} | grep push | cut -d '/' -f 4 | cut -d ' ' -f 1 | cut -d '.' -f 1)
    # Fetch logs
    echo Fetching logs for ${APP}....
    heroku logs -t -a ${APP}
}

# Deploy current branch to heroku
heroku-deploy(){
    if [ -z ${1+x} ]; then echo "Please provide env dev/dev2/stage. Example: heroku-deploy dev"; return; fi
    # Define git remote
    REMOTE=$(echo ${1}-heroku)
    # Define current branch
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    # Wait for confirmation
    echo "Deploying branch [${CURRENT_BRANCH}] to ${REMOTE}..."
    read \?"I am waiting for you to press [Enter] before I continue...."
    # Deploy branch
    git push -f $REMOTE ${CURRENT_BRANCH}:master
}

# Fetch env variables
heroku-env(){
    if [ -z ${1+x} ]; then echo "Please provide env dev/dev2/stage. Example: heroku-env dev"; return; fi
    # Define git remote
    REMOTE=$(echo ${1}-heroku)
    # Define Heroku app name
    APP=$(git remote -v | grep ${REMOTE} | grep push | cut -d '/' -f 4 | cut -d ' ' -f 1 | cut -d '.' -f 1)
    # Fetch logs
    echo Fetching env for ${APP}....
    heroku config -a ${APP} | sed 's/:/=/'
}

# Add heroku remote
heroku-reg(){
    if [ -z ${1+x} ]; then echo "Please provide env dev/dev2/stage. Example: heroku-reg dev"; return; fi
    # Heroku Git remote name
    REMOTE=${${2}-heroku}
    heroku git:remote -a ${1} -r $REMOTE
}

# source ~/.local/zsh-autosuggestions/zsh-autosuggestions.zsh
# alias  wi="iwctl station wlan0"

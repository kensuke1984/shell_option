#### .zshrc v0.0.5 2021/5/30

# detection of the OS
isdarwin(){
  [[ "$OSTYPE" == darwin* ]] && return 0 || return 1
}

islinux(){
  [[ "$OSTYPE" == linux-gnu ]] && return 0 || return 1
}

isemacs(){
  [ -n "$EMACS" ] && return 0 || return 1
}

# Kibrary
[ -e "$HOME/Kibrary" ] && export PATH="$HOME/Kibrary/bin:$PATH"

kibrary_install(){
  kins=$(mktemp)
  if command -v curl >/dev/null 2>&1; then
    curl -sL -o "$kins" https://bit.ly/2YUfEB6
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$kins" https://bit.ly/2YUfEB6
  fi
  /bin/sh "$kins"
  rm -f "$kins"
}

anisotime_install(){
  if [ -f 'anisotime' ]; then
    printf 'anisotime already exists.\n'
    return 1
  fi
  if command -v curl >/dev/null 2>&1; then
    curl -sL -o anisotime https://bit.ly/2Xdq5QI
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O anisotime https://bit.ly/2Xdq5QI
  fi
  chmod +x anisotime
}

# git
if command -v git >/dev/null 2>&1; then
  git config --global user.name 'kensuke'
  git config --global user.email 'kensuke1984@hotmail.co.jp'
# git config --global core.editor 'vim -c "set fenc=utf-8"'  
fi


# ls color settings
if isdarwin; then
  export LSCOLORS=GxhFCxdxHbegedabagacad
  export CLICOLOR=1
else 
  [ -z "$LS_COLORS" ] && eval "$(dircolors)"
fi

# Lines configured by zsh-newuser-install
HISTFILE="$HOME/.zsh_history_$(hostname)"
HISTSIZE=20000
SAVEHIST=20000
bindkey -e
umask 022

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz zmv
autoload -Uz compinit
compinit
# End of lines added by compinstall

#isdarwin && export SHELL=/usr/local/bin/zsh
export PREFIX=/usr/local

#time zone
export TZ='Asia/Tokyo'
#export TZ='Asia/Taipei'
#export TZ='Europe/Paris'

#character code
export LC_ALL='ja_JP.UTF-8'
# DISPLAY
#export DISPLAY='localhost'
# tmp
#export TMP="${HOME}/tmp"

# less
#export LESSCHARDEF=8bcccbcc18b95.33b33b.
export LESSCHARSET='UTF-8'
#export LESS='-c -m -x4 -R'
export LESS='-isnMCd -c -m -x4 -R'
export LESSBINFMT='*n-'
export PAGER=less
export CLICOLOR_FORCE=1

#---------
# Zsh option
#
# add command history to a file
setopt appendhistory
# move to a directory without 'cd'
setopt autocd
# extend glob ~ ^
setopt extendedglob 
# auto pushd
setopt auto_pushd
# {a-za-z} brace expand
setopt brace_ccl
# expand aliases before completion
setopt complete_aliases
# typo
setopt correct
# if there is already the same history, just bring it to the latest
setopt hist_ignore_all_dups
# if the input is the same as the last one, do nothing on the history
setopt hist_ignore_dups
# if the command starts with spacing, the command is not put in the history
setopt hist_ignore_space
# unnecessary blanks will be removed, when it is put in the history
setopt hist_reduce_blanks
# save immediately after command is performed ( if not, saves on exit )
setopt inc_append_history
# slim completion candidates
setopt list_packed
# display simbols of file types at the end
setopt list_types

setopt pushd_ignore_dups
setopt nomatch
# instantly notify status of jobs
setopt notify
# turn off the beep
unsetopt beep
# share the history file
setopt sharehistory
# set right prompt unvisible
setopt transient_rprompt
# save begins and ends
setopt EXTENDED_HISTORY
# automatically expand the history when completion is done
setopt hist_expand
# not send SIGHUP when exiting
setopt nohup
# Prohibit overwriting by redirection (>)
setopt noclobber

# operate ls_abbrev when 'cd'
function chpwd() {ls_abbrev}

function extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzvf "$1";;
    *.tar.xz) tar Jxvf "$1";;
    *.zip) unzip "$1";;
    *.lzh) lha e "$1";;
    *.tar.bz2|*.tbz) tar xjvf "$1";;
    *.tar.Z) tar zxvf "$1";;
    *.gz) gzip -d "$1";;
    *.bz2) bzip2 -dc "$1";;
    *.Z) uncompress "$1";;
    *.tar) tar xvf "$1";;
    *.arj) unarj "$1";;
  esac
}
isdarwin || alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

# allow to indicate colors as numbers
# 0:black
# 1:red
# 2:green
# 3:yellow
# 4:blue
# 5:magenta
# 6:cyan
# 7:white
# others:black
# %f:reset_color
autoload -Uz colors; colors

# left prompt
      
#PROMPT="%F{green}%n@%m%F{magenta}${WINDOW:+[$WINDOW]}%F{white}[%T]%#%f "
#'%F{yellow}%39<...<%~%k%f'$'\n'
PROMPT='%F{green}%n@%m %F{white}[%T]%f%(?,%F{green},%F{red})%B%(!,#,%#)%b%f '

# right prompt
# display information about VCS(zsh >=4.3.6)
autoload -Uz is-at-least
if is-at-least 4.3.6; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable bzr git svn hg
  if [[ "$TERM" == dumb ]]; then
  # connections via emacs is recognized as a dumb terminal, not use colors
    zstyle ':vcs_info:*' actionformats "(%s%)-[%b|%a] " "zsh: %r"
    zstyle ':vcs_info:*' formats "(%s%)-[%b] " "zsh: %r"
  else
  # color
    zstyle ':vcs_info:*' actionformats '%F{magenta}(%f%s%F{magenta})%F{yellow}-%F{magenta}[%F{green}%b%F{yellow}|%F{red}%a%F{magenta}]%f '
    zstyle ':vcs_info:*' formats '%F{magenta}(%f%s%F{magenta})%F{yellow}-%F{magenta}[%F{green}%b%F{magenta}]%f '
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{red}:%F{yellow}%r'
    zstyle ':vcs_info:bzr:*' use-simple true
    if is-at-least 4.3.10; then
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' stagedstr '+'
      zstyle ':vcs_info:*' unstagedstr '-'
    fi
  fi
fi

function precmd() {
  local color
  if [[ ${PWD}/ == /Volumes/* ]]; then
    color=${fg[yellow]}${bg[red]}
  else
    color=${fg[white]}
  fi
  psvar=()
  vcs_info
  if [ "$EMACS" ]; then
  # not display the right prompt in Emacs ansi-term 
    RPROMPT=''
  else
  # With setopt prompt_subst, variables are available in the prompt.
  # "%39<...<%-" limits 39 letters to show up the rest becomes ...
  #RPROMPT='[%F{green}%39<...<%~%f] ${vcs_info_msg_0_}%f'
    if [[ "${PWD}/" == /Volumes/* ]]; then
    # at Volumes
      RPROMPT='[%F{yellow}%K{red}%39<...<%~%k%f]'
    else
    # not at Volumes 
      RPROMPT='[%F{white}%39<...<%~%f]'
    fi
  fi
}

# red stderr
alias -g RED='2> >(redrev)'

function redrev() {
  perl -pe 's/^/\e[41m/ && s/$/\e[m/'
}

# lscp
lscp(){
  local filename="$(pwd | tr -d '\n')/$1"
  isdarwin && echo -n "$filename" | pbcopy || echo -n "$filename" | xclip -sel clip
  echo "$filename"
}

# platex and dvipdfmx
platex_dvipdfmx(){
  #platex $1 && dvipdfmx ${1%tex}dvi
  platex "$1"; bibtex "${1%.tex}"; platex "$1"; platex "$1"; dvipdfmx "${1%tex}dvi"
}

pdf_merge(){
  [ -e output.pdf ] && echo 'output.pdf exists.' || gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf $@
}

# colors used in coreutils ls and Zsh completion
isdarwin && export LS_COLORS='di=36:ln=37;45:so=32:pi=33:ex=37;41:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

#-----------------------------------------------------------------
# settings for completion
#-----------------------------------------------------------------
# ignored suffix for completion
fignore=(.o .dvi .aux .toc - \~)
# utilize completion
autoload -Uz compinit; compinit

# show all candidates
zstyle ':completion:*' verbose 'yes'
# expand completion
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
# First try to complete as the inputs, if no candidates exist, try to complete case insentively
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[-_.]=**' '+m:{A-Z}={a-z} r:|[-_.]=**'

## color settings
# put colors on completion, following to LSCOLORS
#zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}
# when completion of file list, put colors as coreutils ls does
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# colors for messages
zstyle ':completion:*:messages' format "%{$fg[yellow]%}'%d'%f"
zstyle ':completion:*:warnings' format "%{$fg[red]%}'No matches for:'%{$fg[yellow]%}' %d'%f"
zstyle ':completion:*:descriptions' format "%{$fg[yellow]%}'completing %B%d%b'%f"
zstyle ':completion:*:corrections' format "%{$fg[yellow]%}'%B%d '%{$fg[red]%}'(errors: %e)%b'%f"

# display explain of completion
zstyle ':completion:*:options' description 'yes'
# sudo also gets completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# kill gets completion
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# when copy and paste a URL, automatically escape escape sequences
autoload -Uz url-quote-magic
zstyle ':url-quote-magic:*' url-metas '?'
zle -N self-insert url-quote-magic

#autoload predict-on
#predict-on

typeset -A abbreviations
abbreviations=(
  'Im'    '| more'
  'Il'    '| less'
  'Ia'    '| awk'
  'Ig'    '| grep'
  'Ieg'   '| egrep'
  'Iag'   '| agrep'
  'Igr'   '| groff -s -p -t -e -Tlatin1 -mandoc'
  'Ip'    "| $PAGER"
  'Ih'    '| head'
  'Ik'    '| keep'
  'It'    '| tail'
  'Is'    '| sort'
  'Iv'    "| ${VISUAL:-${EDITOR}}"
  'Iw'    '| wc'
  'Ix'    '| xargs'
  'Ie'    '140.109.81.141:'
  'Lustre' '140.109.81.141:lustre/'
  'Ki'    'https://kensuke1984.github.io/bin/install.sh'
  'Prop'  'properties'
  'Iris'  'ftp.iris.washington.edu'
  'Imp'   'impeldown.64-b.it'
  'Mer'   'merveille.64-b.it'
  'GIT'   'io.github.kensuke1984.'
)

magic-abbrev-expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
  zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey ' ' magic-abbrev-expand
bindkey '^x ' no-magic-abbrev-expand

#Delete Home End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

#alias
aliasfile=~/.aliases
[ -r "$aliasfile" ] && source "$aliasfile"
unset aliasfile

unalias run-help 2>/dev/null
autoload run-help
HELPDIR=/usr/local/share/zsh/help

eps(){
  eps2eps "$1" "${1}~"
  /bin/mv "${1}~" "$1"
} 

iris(){
  expect -c '
  spawn -noecho ftp -i ftp.iris.washington.edu
  expect "Name*"
  send "ftp\n"
  expect "Password:"
  send "kensuke1984@gate.sinica.edu.tw\n"
  expect "Using binary mode to transfer files."
  send "cd pub/userdata/kensuke\n"
  interact'
}

ls_abbrev() {
  [ -r "${PWD}" ] || return
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  case "${OSTYPE}" in freebsd*|darwin*)
  if type gls >/dev/null 2>&1; then
    cmd_ls='gls'
  else
  # -G : Enable colorized output.
    opt_ls=('-aCFG')
  fi
  ;;
  esac
  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')
  local ls_lines="$(echo "$ls_result" | wc -l | tr -d ' ')"
  if [ "$ls_lines" -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}

epspng(){
  convert "$1" "${1%eps}png"
}

isdarwin || setxkbmap -option ctrl:nocaps

if isdarwin && [ -e "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# for SAC
#SACHOME=/usr/local/sac
#[ -e "$SACHOME" ] && source "${SACHOME}/bin/sacinit.sh" || (unset SACHOME; printf 'SAC should be installed\n' 1>&2)

# for TauP
#TAUPHOME=/usr/local/taup
#[ -e "${TAUPHOME}" ] && export "PATH=$PATH:${TAUPHOME}/bin" || printf 'TauP should be installed\n' 1>&2
#unset TAUPHOME

#sgftops
function sgftops(){
  if [ ! -e "${SACHOME}/bin/sgftops" ]; then
    printf 'SACHOME is not set. (71)\n' 1>&2
    exit 71
  fi
  if [ -e "${1%sgf}ps" ]; then
    printf '%s already exists. (9)\n' "${1%sgf}.ps" 1>&2
    return 9
  fi
  "${SACHOME}/bin/sgftops" "$1" "${1%sgf}ps"
}

# local settings
zshrc_local="$HOME/.zshrc_$(hostname)"
[ -r "$zshrc_local" ] && source "$zshrc_local"
unset zshrc_local

# Delete duplicates
typeset -U path cdpath fpath manpath
typeset -T LD_LIBRARY_PATH ld_library_path
typeset -U ld_library_path

# Attempt to set JAVA_HOME if it's not already set.
if [ -z "$JAVA_HOME" ]; then
  if isdarwin; then
    if [ -f /usr/libexec/java_home ]; then
      export JAVA_HOME=$(/usr/libexec/java_home)
    elif [ -d /Library/Java/Home ]; then
      export JAVA_HOME=/Library/Java/Home
    elif [ -d /System/Library/Frameworks/JavaVM.framework/Home ]; then
      export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
    fi
  else
    javaExecutable="$(command -v javac 2>/dev/null)"
    [ -z "$javaExecutable" ] && echo "JAVA_HOME not set and cannot find javac to deduce location, please set JAVA_HOME." 
    readLink="$(command -v readlink 2>/dev/null)"
    [ -z "$readLink" ] && echo "JAVA_HOME not set and readlink not available, please set JAVA_HOME."
    javaExecutable="$(readlink -f "$javaExecutable")"
    javaHome="$(dirname "$javaExecutable")"
    javaHome=$(expr "$javaHome" : '\(.*\)/bin')
    JAVA_HOME="$javaHome"
    [ -z "$JAVA_HOME" ] && echo 'could not find java, please set JAVA_HOME'
    export JAVA_HOME
  fi
fi



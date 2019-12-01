#detection of the OS
isdarwin(){
  [[ $OSTYPE == darwin* ]] && return 0
  return 1
}
islinux(){
  [[ $OSTYPE == linux-gnu ]] && return 0
  return 1
}
isemacs(){
  [[ "$EMACS" != "" ]] && return 0
  return 1
}
kibrary_install(){
  if command -v curl >/dev/null 2>&1;then
     kins=$(mktemp) && curl -s -o $kins https://kensuke1984.github.io/bin/install.sh && /bin/sh $kins && rm -f $kins
  elif command -v wget >/dev/null 2>&1;then
    kins=$(mktemp) && wget -q -O $kins https://kensuke1984.github.io/bin/install.sh && /bin/sh $kins && rm -f $kins
  fi
}

#ls color settings
isdarwin && export CLICOLOR=1
isdarwin && export LSCOLORS=GxhFCxdxHbegedabagacad
#
autoload -Uz zmv

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history_linux
HISTSIZE=20000
SAVEHIST=20000
bindkey -e
umask 022

#Intel compiler
test -r /opt/intel/bin/compilervars.sh && source /opt/intel/bin/compilervars.sh intel64
#
#
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/kensuke/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#isdarwin && export SHELL=/usr/local/bin/zsh
export PREFIX=/usr/local

#time zone
#export TZ='Asia/Tokyo'
export TZ='Asia/Taipei'
#export TZ='Europe/Paris'

#character code
export LC_ALL="ja_JP.UTF-8"
# DISPLAY
#export DISPLAY="localhost"
# tmp
#export TMP="${HOME}/tmp"


# less
#export LESSCHARDEF=8bcccbcc18b95.33b33b.
export LESSCHARSET="UTF-8"
#export LESS='-c -m -x4 -R'
export LESS="-isnMCd -c -m -x4 -R"
export LESSBINFMT='*n-'
export PAGER=less
export CLICOLOR_FORCE=1


#---------
#Zsh option
#
# add command history to a file
setopt appendhistory
#move to a directory without 'cd'
setopt autocd
# 正規表現の拡張　# ~ ^
setopt extendedglob 
# auto pushd
setopt auto_pushd
#{a-za-z} ブレース展開
setopt brace_ccl
#補完動作前にエイリアス展開
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
# コマンド確定後すぐに履歴ファイルに保存する(設定しないと exit 時)
setopt inc_append_history
# 補完候補をコンパクトにする
setopt list_packed
# ファイル種別を表す記号を末尾に表示
setopt list_types

setopt pushd_ignore_dups
setopt nomatch
#ジョブの状態をすぐに知らせる
setopt notify
#turn off the beep
unsetopt beep
#share the history file
setopt sharehistory
#set right prompt unvisible
setopt transient_rprompt
#開始と終了を記録
setopt EXTENDED_HISTORY
#補完時にヒストリを自動的に展開
setopt hist_expand
#シェルの終了処理でSIGHUPを送らないオプション
setopt nohup
#Prohibit overwriting by redirection (>)
setopt noclobber

# operate ls_abbrev when 'cd'
function chpwd(){ls_abbrev}

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


# カラー記述を簡略化
# 数字や文字で色を指定できるようにする
# 0:black
# 1:red
# 2:green
# 3:yellow
# 4:blue
# 5:magenta
# 6:cyan
# 7:white
# それ以外：black
# %f:reset_color
autoload -Uz colors; colors

#左プロンプト
#PROMPT="%F{green}%n@%m%F{magenta}${WINDOW:+[$WINDOW]}%F{white}[%T]%#%f "
PROMPT="%F{green}%n@%m %F{white}[%T]%#%f "


# 右プロンプト
# バージョン管理システム関連の情報を表示(zsh >=4.3.6)
autoload -Uz is-at-least
if is-at-least 4.3.6; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable bzr git svn hg
  if [[ "$TERM" == dumb ]] ; then
  # emacs 等から接続すると dumb 端末と認識され、そうした端末では色を出さないようにする
    zstyle ':vcs_info:*' actionformats "(%s%)-[%b|%a] " "zsh: %r"
    zstyle ':vcs_info:*' formats "(%s%)-[%b] " "zsh: %r"
  else
  # 色をつける
    zstyle ':vcs_info:*' actionformats '%F{magenta}(%f%s%F{magenta})%F{yellow}-%F{magenta}[%F{green}%b%F{yellow}|%F{red}%a%F{magenta}]%f '
    zstyle ':vcs_info:*' formats '%F{magenta}(%f%s%F{magenta})%F{yellow}-%F{magenta}[%F{green}%b%F{magenta}]%f '
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{red}:%F{yellow}%r'
    zstyle ':vcs_info:bzr:*' use-simple true
    if is-at-least 4.3.10; then
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' stagedstr "+"
      zstyle ':vcs_info:*' unstagedstr "-"
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
  if [ "$EMACS" ];then
  # Emacs の ansi-term では右プロンプトを表示しない
    RPROMPT=""
  else
  # setopt prompt_subst を設定するとプロンプトに変数そのまま記述できる
  # %39<...<%- は 39文字以上になったら前方を ... に置換する設定
  #RPROMPT='[%F{green}%39<...<%~%f] ${vcs_info_msg_0_}%f'
    if [[ ${PWD}/ == /Volumes/* ]]; then
    # Volumes 以下にいる場合
      RPROMPT='[%F{yellow}%K{red}%39<...<%~%k%f]'
    else
    # Volumes 以下にいない場合
      RPROMPT='[%F{white}%39<...<%~%f]'
    fi
  fi
}

#red stderr
alias -g RED='2> >(redrev)'

function redrev() {
  perl -pe 's/^/\e[41m/ && s/$/\e[m/'
}

#lscp
lscp(){
  local filename="$(pwd | tr -d '\n')/$1"
  isdarwin && echo -n "$filename" | pbcopy || echo -n "$filename" | xclip -sel clip
  echo "$filename"
}

#platex and dvipdfmx
platex_dvipdfmx(){
  #platex $1 && dvipdfmx ${1%tex}dvi
  platex "$1"; bibtex "${1%.tex}"; platex "$1"; platex "$1"; dvipdfmx "${1%tex}dvi"
}

pdf_merge(){
test -e output.pdf && echo 'output.pdf exists.' || gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=output.pdf $@
}



# coreutils ls および Zsh 補完色用の設定
isdarwin && export LS_COLORS='di=36:ln=37；45:so=32:pi=33:ex=37;41:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

#-----------------------------------------------------------------
# 補完設定
#-----------------------------------------------------------------
# 補完無視ファイル設定
fignore=(.o .dvi .aux .toc - \~)
# 補完の利用設定
autoload -Uz compinit; compinit

## 補完設定
# 補完表示を全てする
zstyle ':completion:*' verbose 'yes'
# 補完の機能を拡張
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
# 補完候補で入力された文字でまず補完してみて、補完不可なら大文字小文字を変換して補完する
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[-_.]=**' '+m:{A-Z}={a-z} r:|[-_.]=**'

## 色設定
# 補完候補に LSCOLORS 同様色を付与
#zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}
# ファイルリスト補完でも coreutils ls と同様に色をつける
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# 補完メッセージの色
zstyle ':completion:*:messages' format "%{$fg[yellow]%}'%d'%f"
zstyle ':completion:*:warnings' format "%{$fg[red]%}'No matches for:'%{$fg[yellow]%}' %d'%f"
zstyle ':completion:*:descriptions' format "%{$fg[yellow]%}'completing %B%d%b'%f"
zstyle ':completion:*:corrections' format "%{$fg[yellow]%}'%B%d '%{$fg[red]%}'(errors: %e)%b'%f"

# 補完説明を表示する
zstyle ':completion:*:options' description 'yes'
# sudo でも補完の対象とする
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# kill 補完で実行されるコマンドを指定
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# URLをコピペした時にエスケープ対象文字を自動エスケープする
autoload -Uz url-quote-magic
zstyle ':url-quote-magic:*' url-metas '?'
zle -N self-insert url-quote-magic


#autoload predict-on
#predict-on

typeset -A abbreviations
abbreviations=(
  "Im"    "| more"
  "Il"    "| less"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Ieg"   "| egrep"
  "Iag"   "| agrep"
  "Igr"   "| groff -s -p -t -e -Tlatin1 -mandoc"
  "Ip"    "| $PAGER"
  "Ih"    "| head"
  "Ik"    "| keep"
  "It"    "| tail"
  "Is"    "| sort"
  "Iv"    "| ${VISUAL:-${EDITOR}}"
  "Iw"    "| wc"
  "Ix"    "| xargs"
  "Ie"    "140.109.81.141:"
  "Lustre" "140.109.81.141:lustre/"
  "Ki"    "https://kensuke1984.github.io/bin/install.sh"
  "Prop"  "properties"
  "Iris"  "ftp.iris.washington.edu"
  "Imp"   "impeldown.001www.com"
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
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

#Delete Home End keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

#alias
aliasfile=~/.aliases
test -r "$aliasfile" && source "$aliasfile"
unset aliasfile
#

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
  if [[ ! -r $PWD ]]; then
    return
  fi
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  case "${OSTYPE}" in freebsd*|darwin*)
  if type gls > /dev/null 2>&1; then
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

#
# Attempt to set JAVA_HOME if it's not already set.
if [ -z "$JAVA_HOME" ]; then
  if isdarwin; then
    [ -z "$JAVA_HOME" -a -f "/usr/libexec/java_home" ] && export JAVA_HOME=$(/usr/libexec/java_home)
    [ -z "$JAVA_HOME" -a -d "/Library/Java/Home" ] && export JAVA_HOME="/Library/Java/Home"
    [ -z "$JAVA_HOME" -a -d "/System/Library/Frameworks/JavaVM.framework/Home" ] && export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
  else
    javaExecutable="$(command -v javac 2>/dev/null)"
    [[ -z "$javaExecutable" ]] && echo "JAVA_HOME not set and cannot find javac to deduce location, please set JAVA_HOME." 
    readLink="$(command -v readlink 2>/dev/null)"
    [[ -z "$readLink" ]] && echo "JAVA_HOME not set and readlink not available, please set JAVA_HOME."
    javaExecutable="$(readlink -f "$javaExecutable")"
    javaHome="$(dirname "$javaExecutable")"
    javaHome=$(expr "$javaHome" : '\(.*\)/bin')
    JAVA_HOME="$javaHome"
    [[ -z "$JAVA_HOME" ]] && echo "could not find java, please set JAVA_HOME"
    export JAVA_HOME
  fi
fi

isdarwin || setxkbmap -option ctrl:nocaps

pyenv="$HOME/.pyenv"
test -e "$pyenv" && export PATH="$pyenv/bin:$PATH" && eval "$(pyenv init -)"
isdarwin && eval "$(/usr/local/bin/pyenv init -)"

#for TauP
TAUPHOME=/usr/local/taup
test -e ${TAUPHOME} && export PATH=$PATH:${TAUPHOME}/bin
unset TAUPHOME
#

#for evalresp
test -r /usr/local/evalresp && export PATH=$PATH:/usr/local/evalresp/bin
#

#for netcdf
test -r /usr/local/netcdf && export PATH=$PATH:/usr/local/netcdf/bin
#

#for Tex
TEXLIVE=/usr/local/texlive/2016
test -e $TEXLIVE/bin/x86_64-linux && export PATH=$PATH:$TEXLIVE/bin/x86_64-linux
test -e $TEXLIVE/texmf-dist/doc/info && export INFOPATH=$INFOPATH:$TEXLIVE/texmf-dist/doc/info
test -e $TEXLIVE/texmf-dist/doc/man && export MANPATH=$MANPATH:$TEXLIVE/texmf-dist/doc/man
unset TEXLIVE
#

# for SAC
SACHOME=/usr/local/sac
test -e $SACHOME && source ${SACHOME}/bin/sacinit.sh || unset SACHOME
#
#sgftops
function sgftops(){
  if [[ -e "${1%sgf}ps" ]]; then
    printf "%s already exists.\n" "${1%sgf}.ps"
    return 9
  fi
  ${SACHOME}/bin/sgftops "$1" "${1%sgf}ps"
}

#for hdf5
hdfPATH=/usr/local/hdf5
test -r $hdfPATH && export CPPFLAGS=-I$hdfPATH/include
test -r $hdfPATH && export LDFLAGS=-L$hdfPATH/lib
test -r $hdfPATH && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$hdfPATH/lib
unset hdfPATH
#

#for MPI
test -r /usr/local/openmpi && export PATH=/usr/local/openmpi/bin:$PATH
#


#PGI
export PGI=/opt/pgi
export PATH=/opt/pgi/linux86-64/19.10/bin:$PATH
export MANPATH=$MANPATH:/opt/pgi/linux86-64/19.10/man
export LM_LICENSE_FILE=$LM_LICENSE_FILE:/opt/pgi/license.dat

#Python
#conpath="$HOME/.pyenv/versions/anaconda3-4.4.0"
#sitepath="$conpath/lib/python3.6/site-packages"
#test -e "$conpath" && export PATH="$conpath/bin:$PATH"
#test -e "$sitepath" && export PYTHONPATH="$sitepath":$PYTHONPATH
#unset sitepath conpath
#

#Kibrary
#kibraryrc="$HOME/.Kibrary/bin/init_bash.sh"
#test -e "$kibraryrc" && source $kibraryrc
#unset kibraryrc
#

# Delete duplicates
typeset -U path cdpath fpath manpath
typeset -T LD_LIBRARY_PATH ld_library_path
typeset -U ld_library_path
#

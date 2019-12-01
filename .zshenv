# set man command env.
export MANPATH=/usr/share/man:/usr/local/share/man
export MANPAGER=/usr/bin/less
export MANWIDTH=80

#JDK man
test -r /usr/java/default/man && export MANPATH=$MANPATH:/usr/java/default/man

#for Groovy
test -r /usr/local/opt/groovy/libexec && export GROOVY_HOME=/usr/local/opt/groovy/libexec

#unsetopt NOMATCH # or setopt NONOMATCH *をうまく使う

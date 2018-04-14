# Created by newuser for 5.0.2
# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
# export EDITOR=/usr/local/bin/vim
export VISUAL=vim

# ページャ
# export PAGER=/usr/local/bin/vimpager
# export MANPAGER=/usr/local/bin/vim

#色の定義
autoload -U colors ; colors
local DEFAULT=%{$reset_color%}
local RED=%{$fg[red]%}
local GREEN=%{$fg[green]%}
local YELLOW=%{$fg[yellow]%}
local BLUE=%{$fg[blue]%}
local PURPLE=%{$fg[purple]%}
local CYAN=%{$fg[cyan]%}
local WHITE=%{$fg[white]%}

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -Uz add-zsh-hook
# autoload -U promptinit; promptinit
autoload -Uz vcs_info
autoload -Uz is-at-least

# begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
    zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
    zstyle ":vcs_info:git:*" stagedstr "<S>"
    zstyle ":vcs_info:git:*" unstagedstr "<U>"
    zstyle ":vcs_info:git:*" formats "(%b) %c%u"
    zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

# end VCS

# PROMPT="$GREEN%m$DEFAULT:$CYAN%n$DEFAULT%% "
PROMPT="%B$GREEN%n$DEFAULT%b@%B$CYAN%m$DEFAULT%b "

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

RPROMPT="["
RPROMPT+="$BLUE%~%f$DEFAULT"
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT+="%1(v|%F{green}%1v%f|)"
RPROMPT+="]"

SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"

# -------------------------------------
# 履歴
# -------------------------------------
# 履歴
HISTFILE=~/.zsh_histfile
HISTSIZE=1000000
SAVEHIST=1000000
# 履歴を複数端末間で共有する。
setopt share_history
# 重複するコマンドが記憶されるとき、古い方を削除する。
setopt hist_ignore_all_dups
# 直前のコマンドと同じ場合履歴に追加しない。
setopt hist_ignore_dups
# 重複するコマンドが保存されるとき、古い方を削除する。
setopt hist_save_no_dups
# コマンド履歴呼び出し
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# -------------------------------------
# 補完機能
# -------------------------------------

# 補完機能の強化
autoload -U compinit
compinit

#補完に関するオプション
setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
# setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt interactive_comments  # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

setopt print_eight_bit       # 日本語ファイル名等8ビットを通す
setopt extended_glob         # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots              # 明確なドットの指定なしで.から始まるファイルをマッチ

setopt list_packed           # リストを詰めて表示

bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)

# 補完候補を ←↓↑→ でも選択出来るようにする
zstyle ':completion:*:default' menu select=2

# 補完関数の表示を過剰にする編
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'

# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

#LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# -------------------------------------
# 補正機能
# -------------------------------------
## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct


# -------------------------------------
# 名前付きディレクトリ
# -------------------------------------
setopt CDABLE_VARS
hash -d doc=/Users/seventh/Documents
hash -d rails_apps=/Users/seventh/RailsApps

# -------------------------------------
# auto cd
# -------------------------------------
# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# -------------------------------------
# auto pushd
# -------------------------------------
# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# -------------------------------------
# zshのその他のオプション
# -------------------------------------
# ビープを鳴らさない
setopt nobeep

## 色を使う
# setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

# -------------------------------------
# パス
# -------------------------------------
# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
#    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# エイリアス
# -------------------------------------

# global alias
alias -g G="| grep"
alias -g ...='../..'
alias -g ....='../../..'

# suffix alias
alias -s py=python

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
case ${OSTYPE} in
  darwin*)
    alias ls="ls -G" # color for darwin
    ;;
  linux*)
    alias ls="ls --color" # color for linux
    ;;
esac
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# for rails alias

alias devlog='tail -f log/development.log'
alias prodlog='tail -f log/production.log'
alias testlog='tail -f log/test.log'
 
alias -g RED='RAILS_ENV=development'
alias -g REP='RAILS_ENV=production'
alias -g RET='RAILS_ENV=test'
 
# Rails aliases
alias rc='rails console'
alias rd='rails destroy'
alias rdb='rails dbconsole'
alias rg='rails generate'
alias rgm='rails generate migration'
alias rp='rails plugin'
alias ru='rails runner'
alias rs='rails server -b 0.0.0.0'
alias rsd='rails server -b 0.0.0.0 --debugger'
alias rsp='rails server -b 0.0.0.0 --port'
 
# Rake aliases
alias rdm='rake db:migrate'
alias rdms='rake db:migrate:status'
alias rdr='rake db:rollback'
alias rdc='rake db:create'
alias rds='rake db:seed'
alias rdd='rake db:drop'
alias rdrs='rake db:reset'
alias rdtc='rake db:test:clone'
alias rdtp='rake db:test:prepare'
alias rdmtc='rake db:migrate db:test:clone'
alias rlc='rake log:clear'
alias rn='rake notes'
alias rr='rake routes'
alias rrg='rake routes | grep'
alias rt='rake test'
alias rmd='rake middleware'
alias rsts='rake stats'

# vim
# alias vim="/usr/local/bin/vim"
alias v='vim'

# jupyter notebook
alias jn='jupyter notebook'
alias ip='ipython'

# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -d
bindkey -e

bindkey '^f' forward-word
bindkey '^b' backward-word
bindkey '^d' kill-word

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# contributions
# -------------------------------------
# smart-insert-last-word
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word

# cdr
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
 
# cdr の設定
zstyle ':completion:*' menu select
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 20
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# zmv
autoload -Uz zmv
# alias zmv='noglob zmv -W'

# コマンドをエディタで修正する
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# -------------------------------------
# zgen
# -------------------------------------
source ~/.zgen/zgen.zsh

if ! zgen saved; then
  zgen load zsh-users/zsh-completions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load mollifier/anyframe
  zgen load supercrabtree/k
  zgen load b4b4r07/enhancd
 
  # pure
  # antigen bundle mafredri/zsh-async
  # antigen bundle sindresorhus/pure

  zgen save
fi

# -------------------------------------
# anyframe
# -------------------------------------
bindkey '^xb' anyframe-widget-cdr
bindkey '^x^b' anyframe-widget-checkout-git-branch

bindkey '^xr' anyframe-widget-execute-history
bindkey '^x^r' anyframe-widget-execute-history

bindkey '^xp' anyframe-widget-put-history
bindkey '^x^p' anyframe-widget-put-history

bindkey '^xg' anyframe-widget-cd-ghq-repository
bindkey '^x^g' anyframe-widget-cd-ghq-repository

bindkey '^xk' anyframe-widget-kill
bindkey '^x^k' anyframe-widget-kill

bindkey '^xi' anyframe-widget-insert-git-branch
bindkey '^x^i' anyframe-widget-insert-git-branch

bindkey '^xf' anyframe-widget-insert-filename
bindkey '^x^f' anyframe-widget-insert-filename

# -------------------------------------
# その他
# -------------------------------------
# cdしたあとで、自動的に ls する
function chpwd() { ls }

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
  }

# agvim
function agvim () {
  vim $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

# cdup
function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
alias 'cd..'=cdup

# peco find file
function peco-find-file() {
    if git rev-parse 2> /dev/null; then
        source_files=$(git ls-files)
    else
        source_files=$(find . -type f)
    fi
    selected_files=$(echo $source_files | peco --prompt "[find file]")

    result=''
    for file in $selected_files; do
        result="${result}$(echo $file | tr '\n' ' ')"
    done

    BUFFER="${BUFFER}${result}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-find-file
bindkey '^Q' peco-find-file

# Load specific settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# if type zprof > /dev/null 2>&1; then
  # zprof | less
# fi

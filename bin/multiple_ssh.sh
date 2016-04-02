#!/bin/bash

function usage {
    cat <<EOF
$(basename ${0}) is a multiple ssh connection

Usage:
  $(basename ${0}) [options or host] [<host(list)> or <host>]

Options:
    --file, -f        connect ssh use host list file
    --version, -v     print $(basename ${0}) version
    --help, -h        print this
    --percol, -p      exec percol host select mode
EOF
}

function version {
    echo "$(basename ${0}) version 0.0.1 "
}

function use_host_file {
  local HOST_FILE=${1}

  if [ -z "${HOST_FILE}" ]; then
    echo "Error: please appoint host list file."
    exit 1
  fi

  if [ -f "${HOST_FILE}" ]; then
    HOST1=`cat ${HOST_FILE} |head -1`
    HOST_LIST=`cat ${HOST_FILE} |tail -n +2`
  else
    echo "Error: No such file."
    exit 1
  fi
}

function percol_select_mode {
  if [ -d "~/.ssh/config.d" ]; then
    rm -f ~/.ssh/config
    cat ~/.ssh/config.d/* > ~/.ssh/config
  fi
  HOSTS=$(grep "^\s*Host " ~/.ssh/config | sed s/"[\s ]*Host "// | grep -v "^\*$" | sort | percol)

  HOST1=`echo $HOSTS |awk '{print $1}'`
  HOST_LIST=`echo $HOSTS|awk -F' ' '{for(i=2;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}'`
}

case ${1} in
  help|--help|-h)
      usage
  ;;
  version|--version|-v)
      version
  ;;
  file|--file|-f)
      use_host_file ${2}
  ;;
  percol|--percol|-p)
      percol_select_mode
  ;;
  ''|-*)
      usage
      exit 1
  ;;
  *)
     HOST1=$1
     shift
     HOST_LIST=$*
  ;;
esac

if [ -n "$SESSION_NAME" ];then
  session=$SESSION_NAME
else
  session=multi-ssh-`date +%s`
fi
window=multi-ssh

### tmuxのセッションを作成
if [ -z "`pgrep tmux`" ]; then
  tmux new-session -d -n $window -s $session
fi

### 各ホストにsshログイン
# 最初の1台はsshするだけ
tmux rename-window $HOST1
tmux send-keys "ssh $HOST1" C-m \; pipe-pane -o '/bin/sh -c "tmux_logging.sh ~/.tmux/log #S #I #P #W"'

# 残りはpaneを作成してからssh
for HOST in $HOST_LIST;do
  tmux rename-window $HOST
  tmux split-window
  tmux select-layout tiled
  tmux send-keys "ssh $HOST" C-m \; pipe-pane -o '/bin/sh -c "tmux_logging.sh ~/.tmux/log #S #I #P #W"'
done

### 最初のpaneを選択状態にする
tmux select-pane -t 0

### paneの同期モードを設定
tmux set-window-option synchronize-panes on

### セッションにアタッチ
tmux attach-session -t $session

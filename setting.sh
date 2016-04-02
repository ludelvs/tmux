#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0) && pwd)

if [ ! -d "/usr/local/bin" ]; then
  mkdir /usr/local/bin
fi

if [ ! -f "/usr/local/bin/tmux_logging.sh" ]; then
  ln -s $CURRENT_DIR/bin/tmux_logging.sh /usr/local/bin
fi

if [ ! -f "/usr/local/bin/mssh" ]; then
  ln -s $CURRENT_DIR/bin/multiple_ssh.sh /usr/local/bin/mssh
fi

echo $PATH |grep -v "\/usr/\/local\/bin" > /dev/null 2>&1
if [ ! "${?}" ]; then
  export PATH="/usr/local/bin:$PATH"
fi

if [ ! -f "${HOME}/.tmux.conf" ]; then
  ln -s $CURRENT_DIR/etc/tmux.conf ${HOME}/.tmux.conf
fi

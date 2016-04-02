#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0) && pwd)

if [ ! -f "/usr/local/bin/tmux_logging.sh" ]; then
  ln -s $CURRENT_DIR/bin/tmux_logging.sh /usr/local/bin
fi

echo $PATH |grep -v "\/usr/\/local\/bin" > /dev/null 2>&1
if [ ! "${?}" ]; then
  export PATH="/usr/local/bin:$PATH"
fi

if [ ! -f "${HOME}/.tmux.conf" ]; then
  ln -s $CURRENT_DIR/etc/tmux.conf ${HOME}/.tmux.conf
fi

#!/bin/bash

LOG_DIR=$1

SESSION_NAME=$2 #S
WINDOW_INDEX=$3 #I
PAIN_INDEX=$4 #P
WINDOW_NAME=$5 #W

LOG_DIR="${LOG_DIR}/$(date +%Y%m)/$(date +%Y%m%d)"

if [ ! -d "${LOG_DIR}" ]; then
  mkdir -p ${LOG_DIR}
fi

INDEXES=${SESSION_NAME}.${WINDOW_INDEX}.${PAIN_INDEX}.${WINDOW_NAME}

LOG_FILE=${LOG_DIR}/$(date +%Y%m%d-%H%M%S)-${INDEXES}.log

while read -r LINE
do
  echo "[$(date +%Y%m%d_%H%M%S)] ${LINE}" >> ${LOG_FILE}
done

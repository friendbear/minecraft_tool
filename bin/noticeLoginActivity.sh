#!/bin/bash
set -eux

TMP_ROOT=/home/tomohiro_kumagai/tmp
# 実行時の日時から、何秒前のレコードをSlack通知の対象とするか
INTERVAL=5
# ログファイルのフルパス
#LOGFILENAME=$1
LOGFILENAME=/home/minecraft/logs/latest.log

checked_line=0
unchecked_line=$(wc -l $LOGFILENAME | cut -d ' ' -f1)
if [ -f $TMP_ROOT/lines.txt ]; then
  checked_line=$(cat $TMP_ROOT/lines.txt)
  echo $unchecked_line > $TMP_ROOT/lines.txt
fi
check_line=$(expr $unchecked_line - $checked_line)
if [ $check_line -lt 0 ]; then
  $check_line=0
  echo $check_line > $TMP_ROOT/lines.txt

fi
(tail -n $check_line $LOGFILENAME | grep 'logged in' | cut -d$' ' -f4-) > $TMP_ROOT/login.txt

cat $TMP_ROOT/login.txt | while read  line
do

  #if echo $line | grep "logged in"; then
    set -- $line
    time=$1
    echo "{$line}" | sh -x /home/tomohiro_kumagai/bin/webhook.sh
  #fi
done

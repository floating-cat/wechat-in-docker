#!/bin/sh

# https://zhuanlan.zhihu.com/p/106926984
function removeWeChatShadowAtIntervals {
  readonly CHECK_INTERVAL_IN_SEC=1

  while true; do
    read -r WCWID WCW WCH <<< $(wmctrl -l -G -x | grep wechat.exe | awk '{printf "%s %s %s\n",$1,$5,$6}'); xwininfo -root -children | grep wechat.exe | grep $(expr $WCW + 40)x$(expr $WCH + 40) | awk '{print $1}' | xargs xdotool windowunmap  &> /dev/null

    sleep $CHECK_INTERVAL_IN_SEC
  done
}

removeWeChatShadowAtIntervals &
/opt/apps/com.qq.weixin.spark/files/run.sh

# https://stackoverflow.com/a/22644006
trap "exit" INT TERM
trap "kill 0" EXIT

#!/bin/sh

# https://zhuanlan.zhihu.com/p/106926984
function removeWeChatShadowAtIntervals {
  readonly CHECK_INTERVAL_IN_SEC=1

  while true; do
    window_id=$(wmctrl -lx | grep wechat.exe | awk '{print $1}'| sed -n 's/09$/0d/p;s/10$/1f/p')
    window_id2=$(echo $window_id | sed -n 's/1f$/23/p')

    if [ -n "$window_id" ]; then
      xdotool windowunmap "$window_id" &> /dev/null
    fi
    if [ -n "$window_id2" ]; then
      xdotool windowunmap "$window_id2" &> /dev/null
    fi

    sleep $CHECK_INTERVAL_IN_SEC
  done
}

removeWeChatShadowAtIntervals &
/opt/apps/com.qq.weixin.spark/files/run.sh

# https://stackoverflow.com/a/22644006
trap "exit" INT TERM
trap "kill 0" EXIT

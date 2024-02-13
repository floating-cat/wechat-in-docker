# WeChat in Docker

Run [WeChat Spark version](https://aur.archlinux.org/packages/com.qq.weixin.spark) from Docker on Linux.

## Usage

1. Run `xhost +local:root` (or `xhost -SI:localuser:$USER` when you are using rootless Containers with Podman) to grant the X11 server access control. The `xhost` command is typically included in a Linux package named `xorg-xhost`, `xhost` or `x11-xserver-utils`.

2. Run below command:
```bash
# Start WeChat for the first time
docker run -it \
    --name wechat \
    --ipc=host `this is needed otherwise WeChat will crash` \
    -e LANG=zh_CN.UTF-8 `make WeChat to use the simplified chinese by default` \
    -e LC_ALL=zh_CN.UTF-8 \
    -e TZ=Asia/Shanghai \
    -e GTK_IM_MODULE=fcitx `change fcitx to iBus if you are using iBus` \
    -e QT_IM_MODULE=fcitx \
    -e XMODIFIERS=@im=fcitx \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -e XDG_RUNTIME_DIR=/tmp `https://stackoverflow.com/a/75776428` \
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 \
    wechat

# Start WeChat for later
docker start wechat
```

You can edit the `/root/.deepinwine/Spark-weixin/scale.txt` file within Docker to change the scale by specifying a number, such as 2.0.

## Limitation

### Compared to WeChat Spark version running without Docker

* The "Open Using Default browser" setting in the WeChat app won't open links in an external browser.
* You can only successfully paste a file from the clipboard to the chat input box when this file is stored in a shared volume with the same path in both the host and Docker.
* The sound only works if the host is using a PipeWire audio server.

### Compared to a native WeChat version

* Emojis are rendered as ▯ (tofu) in the chat input box.
* In-app browser doesn't work.

# WeChat in Docker

Run [WeChat Spark version](https://aur.archlinux.org/packages/com.qq.weixin.spark) from Docker on Linux.

## Usage

1. Run `xhost +SI:localuser:$(id -un)` (or `xhost +SI:localuser:root` when you are running Docker/Podman as a root user) to grant the X11 server access control. The `xhost` command is typically included in a Linux package named `xorg-xhost`, `xhost` or `x11-xserver-utils`.

2. Run below command:
```bash
# Start WeChat for the first time
docker run -it \
    --name wechat \
    -e TZ=Asia/Shanghai \
    -e GTK_IM_MODULE=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e XMODIFIERS=@im=fcitx \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e XDG_RUNTIME_DIR=/tmp \
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 \
    ghcr.io/floating-cat/spark-wechat:latest

# -e XDG_RUNTIME_DIR=/tmp is needed for PipeWire audio support: https://stackoverflow.com/a/75776428
# Note: * please change 'fcitx' to 'iBus' in above command if you are using iBus
#       * if you can't run this command due to '/run/user/1000/pipewire-0: no such file or directory' error
#       please remove '-v /run/user/1000/pipewire-0:/tmp/pipewire-0' command part to disable the audio support
#       or install PipeWire package in your Linux

# Start WeChat for later
docker start wechat
```

You can edit the `/root/.deepinwine/Spark-weixin/scale.txt` file within container to change the scale by specifying a number, such as 2.0.

Optional: Run below command in Bash to add a desktop entry for Linux desktop:

```bash
curl https://www.iconfinder.com/icons/7857168/download/svg/4096 -o ${XDG_DATA_HOME:-$HOME/.local/share}/icons/wechat.svg && echo "
[Desktop Entry]
Name=WeChat
Comment=WeChat Client on Wine
Exec=sh -c \"xhost +SI:localuser:$(id -un) && docker start wechat\"
Icon=${XDG_DATA_HOME:-$HOME/.local/share}/icons/wechat.svg
Terminal=false
StartupWMClass=WeChat.exe
Type=Application
Categories=Chat;InstantMessaging;Network;
Keywords=wechat;wx;wexin;chat;im;messaging;messenger;sms;
" > ${XDG_DATA_HOME:-$HOME/.local/share}/applications/wechat.desktop

# you can find a different WeChat icon here and use it in the curl command: https://www.iconfinder.com/search?q=wechat&price=free
```

## Build container image from source

Run `docker build -t spark-wechat --squash .` (or `podman build -t spark-wechat --layers=true --squash-all .` when you are using Podman).

## Known limitations

### Compared to WeChat Spark version running without container

* The "Open Using Default browser" setting in the WeChat app won't open links in the host's external browser.
* You can only successfully paste a file from the clipboard to the chat input box when this file is stored in a shared volume with the same path in both host and container.
* The sound only works if the host is using a PipeWire audio server.

### Compared to a native WeChat version

* Emojis are displayed as ▯ (tofu) in the chat input box, user names, moments though they can be correctly sent and displayed in the chat window.
* In-app browser doesn't work.

## Credits

https://aur.archlinux.org/packages/com.qq.weixin.spark

https://github.com/276562578/easy_install/blob/4483545f2fd667f24ab9b9e5b6e5d3fcbc69ab31/doc/wechat/linux.md

https://zhuanlan.zhihu.com/p/106926984

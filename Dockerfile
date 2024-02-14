FROM archlinux:base

RUN echo -e '[archlinuxcn]\nServer = https://repo.archlinuxcn.org/$arch' >>/etc/pacman.conf && \
    echo -e 'Server = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch\nServer = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch\nServer = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' >/etc/pacman.d/mirrorlist
Run pacman-key --init && \
    pacman-key --lsign-key "farseerfc@archlinux.org" && \
    pacman -Syu --noconfirm archlinuxcn-keyring && \
    pacman -S --noconfirm paru base-devel

RUN useradd -m makepkg_user && \
    echo "makepkg_user ALL=(ALL) NOPASSWD: ALL">>/etc/sudoers
USER makepkg_user

RUN paru -S --noconfirm com.qq.weixin.spark
RUN paru -S --noconfirm wqy-microhei wqy-zenhei pipewire-alsa wmctrl xdotool xorg-xwininfo && \
    yes | paru -Sccd && \
    sudo pacman -D --asdeps $(pacman -Qqe) && \
    sudo pacman -D --asexplicit base com.qq.weixin.spark wqy-microhei wqy-zenhei pipewire-alsa wmctrl xdotool  xorg-xwininfo && \
    sudo pacman -Qdtq | sudo pacman -Rns --noconfirm -

USER root
COPY run.sh /
CMD ["/run.sh"]

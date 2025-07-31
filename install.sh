#!/data/data/com.termux/files/usr/bin/sh

# Define colours
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

CHROOT=$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu

install_ubuntu(){
echo
if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
echo ${G}"Existing Ubuntu installation found, Resetting it..."${W}
proot-distro reset ubuntu
else
echo ${G}"Installing Ubuntu..."${W}
echo
pkg update
pkg install proot-distro
proot-distro install ubuntu
fi
}

adding_user(){
echo ${G}"Adding a User..."${W}
cat > $CHROOT/root/.bashrc <<- EOF
apt-get update
apt-get install sudo wget -y
sleep 2
useradd -m -s /bin/bash ubuntu
echo "ubuntu:ubuntu" | chpasswd
echo "ubuntu  ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/ubuntu
sleep 2
exit
echo
EOF
proot-distro login ubuntu
echo "proot-distro login --user ubuntu ubuntu" >> $PREFIX/bin/ubuntu
chmod +x $PREFIX/bin/ubuntu
rm $CHROOT/root/.bashrc
}

toolchain(){
echo ${G}"Installing Toolchain"${W}
cat > $CHROOT/root/.bashrc <<- EOF
apt install -y build-essential curl wget git
apt install -y clang-14 lld-14 llvm-14
export CLANG_PATH=/usr/lib/llvm-14/bin
export PATH=/usr/lib/llvm-14/bin:/usr/lib/llvm-14/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:/data/data/com.termux/files/usr/bin:/system/bin:/system/xbin
apt install -y flex bison libssl-dev
exit
EOF
proot-distro login ubuntu
rm $CHROOT/root/.bashrc
}

final_banner(){
echo
echo ${G}"Installion completed"
echo
echo "ubuntu  -  To start Ubuntu"
echo
echo "ubuntu  -  default ubuntu password"
echo
}

install_ubuntu
adding_user
toolchain
final_banner

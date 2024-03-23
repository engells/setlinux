#!/bin/bash
# vim:ts=4
# program: to build a arch linux environmenrt
# made by: Engells
# date: Mar 18, 2024
# content: Add jdownloader and vinegar in list of flatpak


#====副函式======================

_mode_select()
{
case $way1 in
  pre-env)
    _pre_env ;;
  disk-bfs)
    _disk_bfs ;;
  mnt-bfs)
    _mnt_bfs ;;
  bld-base)
    _bld_base ;;
  bld-sys)
    _bld_sys ;;
  bld-sys2)
    _bld_sys2 ;;
  bld-gui)
    _bld_gui ;;
  bld-im)
    _bld_im ;;
  bld-virt)
    _bld_virt ;;
  bld-flat)
    _bld_flatapps ;;
  *)
    echo "Wrong options!"
esac
}

_insall_pkgs()
{
zsh -c "sudo pacman -Syy" && \
zsh -c "sudo pacman -S ${pkgcols}" && \
zsh -c "sudo pacman -Sc --noconfirm"
}

_pre_env()
{
setfont ter-128n
timedatectl set-ntp true && timedatectl status && sleep 5
cp -v /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo 'Server = https://free.nchc.org.tw/arch/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
vim /etc/pacman.d/mirrorlist
pacman -Syy
}

_disk_bfs()
{
mkfs.btrfs -f -L $lname /dev/${bname}${pnum}
mount -t btrfs /dev/${bname}${pnum} /mnt
for vname in os pkgs snapshots res os/arch pkgs/arch res/arch ${hname} ; do btrfs subvolume create /mnt/${vname} ; done
for vname in home mnt virt flatpak qemu lxcd lxcu lxdu podman ; do btrfs subvolume create /mnt/${hname}/${vname} ; done
btrfs subvolume list -a /mnt
df -Th
}

_mnt_bfs()
{
umount /mnt
mkfs.vfat /dev/${bname}1
mount -o defaults,ssd,compress=zstd:3,subvol=os/arch /dev/${bname}${pnum} /mnt
for dname in /mnt/boot/efi /mnt/home /mnt/var/cache/pacman/pkg ; do mkdir -p ${dname} ; done
mount -o defaults,ssd,compress=zstd:3,subvol=pkgs/arch /dev/${bname}${pnum} /mnt/var/cache/pacman/pkg
mount -o defaults,ssd,compress=zstd:3,subvol=res/arch  /dev/${bname}${pnum} /mnt/home
mkdir -p /mnt/home/${uname}0
mount -o defaults,ssd,compress=zstd:3,subvol=${hname}/home /dev/${bname}${pnum} /mnt/home/${uname}0
mount /dev/${bname}1 /mnt/boot/efi
btrfs subvolume list -a /mnt
df -Th
}

_bld_base()
{
pacman -Syy
pacstrap -K /mnt base base-devel linux linux-lts linux-firmware intel-ucode efibootmgr grub os-prober btrfs-progs networkmanager sudo zsh vim git device-mapper util-linux rsync
genfstab -U /mnt >> /mnt/etc/fstab
[[ -f /root/doc/archbld.sh ]] && mkdir -p /mnt/root/doc/ && copy -v /root/doc/* /mnt/root/doc/
# linux-lts don't support arc-a380 vga card
}

_bld_sys()
{
#arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
hwclock --systohc  # create /etc/adjtime

sudo sed -i '/#en_US.UTF-8 UTF-8/s/#//' /etc/locale.gen
sudo sed -i '/#zh_TW.UTF-8 UTF-8/s/#//' /etc/locale.gen
vim /etc/locale.gen
locale-gen

[[ -f /etc/locale.conf ]] && cp /etc/locale.conf /etc/locale.conf.bak || touch /etc/locale.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf

[[ -f /etc/hostname ]] && cp /etc/hostname /etc/hostname.bak || touch /etc/hostname
echo "thaufiin" > /etc/hostname

[[ -f /etc/hosts ]] && cp /etc/hosts /etc/hosts.bak || touch /etc/hosts
  echo "127.0.0.1         localhost" > /etc/hosts
  echo "::1               localhost" >> /etc/hosts
  echo "127.0.1.1         thaufiin" >> /etc/hosts

echo "add password for root and default user ..."
passwd
groupadd -g ${gnum} ${gname}
useradd -u ${unum} -g ${gnum} -m -G users,wheel,audio,video,storage -s /bin/zsh ${uname}
echo "add password for user #1000 ..."
passwd ${uname}

echo "auth sudo for default user ..."
[[ -f /etc/sudoers.d/localuser ]] && cp /etc/sudoers.d/localuser /etc/sudoers.d/localuser.bak || touch /etc/sudoers.d/localuser
echo "${uname} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/localuser

echo "add resolve nameserver ..."
[[ -f /etc/resolv.conf ]] && cp /etc/resolv.conf /etc/resolv.conf.bak || touch /etc/resolv.conf
  echo "nameserver 168.95.192.1" >> /etc/resolv.conf  # 中華電信
  echo "nameserver 168.95.1.1" >> /etc/resolv.conf    # 中華電信
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf       # Google
  echo "nameserver 8.8.4.4" >> /etc/resolv.conf       # Google

echo "add and check tmpfs in /etc/fstab ..."
[[ -f /etc/fstab ]] && cp /etc/fstab /etc/fstab.bak || touch /etc/fstab
  echo "tmpfs    /tmp        tmpfs    defaults,noatime,mode=1777    0   0" >> /etc/fstab
  echo "tmpfs    /var/tmp    tmpfs    defaults,noatime,mode=1777    0   0" >> /etc/fstab
  echo "tmpfs    /var/log    tmpfs    defaults,noexec,mode=1777     0   0" >> /etc/fstab
vim /etc/fstab

echo "add oh my zsh ..."
dname="/home/${uname}/.local/share/oh_my_zsh"
[[ -d ${dname} ]] || mkdir -p ${dname}
git clone https://github.com/robbyrussell/oh-my-zsh.git ${dname}
[[ -f ${dname}/templates/zshrc.zsh-template ]] && cp ${dname}/templates/zshrc.zsh-template /home/${uname}/.zshrc
chown ${uname}:${gname} -R /home/${uname}/ && chown ${uname}:${gname} -R /home/${uname}0/

echo "sync home dir to subvolume mass/home ..."
cd /home/${uname}/ && rsync -avuAHX . /home/${uname}0/ && cd /
for fname in virt qemu/imgs qemu/blks flatpak lxcu podman utils ; do mkdir -p /opt/${fname} ; done
chown ${uname}:${gname} -R /opt/*
mv /home/${uname} /home/${uname}1 && mkdir -p /home/${uname}/mnt && chown ${uname}:${gname} -R /home/${uname}/ && vim /etc/fstab

echo "install grub and net service ..."
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg  # mkinitcpio -p linux, create initramfs
systemctl enable NetworkManager.service
sed -i '/#ParallelDownloads = 5/s/#//' /etc/pacman.conf
}

_bld_sys2()
{
pkgcols='linux-headers linux-lts-headers nvtop usbutils gdisk pacman-contrib p7zip unrar xz ecryptfs-utils cryptsetup neofetch glances lm_sensors smplayer udisks2 tmux smartmontools'
_insall_pkgs
# optional: archlinux-keyring(seems don't support arc-a380 vga card)
}

_bld_gui()
{
pkgcols='xorg xorg-server xorg-xlogo xbitmaps xdg-user-dirs pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber sddm plasma-desktop plasma-nm plasma-pa dolphin konsole okular gwenview kate kscreen ark systemsettings kde-gtk-config breeze-gtk qt6-imageformats kimageformats kwalletmanager'
_insall_pkgs
sudo systemctl enable sddm.service
# optional: xorg-server-xephyr xorg-server-xvfb xpra ;; steghide imagemagick => distrobox # pulseaudio
# plasma-wayland-session => not found in plasma 6 ;; kimageformats5 => kimageformats ;; qt5-imageformats => qt6-imageformats
}

_bld_im()
{
pkgcols='firefox firefox-i18n-zh-tw noto-fonts-cjk noto-fonts-emoji fcitx5-im fcitx5-chewing fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-configtool'
_insall_pkgs
[[ -f /etc/environment ]] || sudo touch /etc/environment
sudo chmod 666 /etc/environment
sudo echo 'XMODIFIERS=@im=fcitx' >> /etc/environment
sudo echo 'GTK_IM_MODULE=fcitx' >> /etc/environment
sudo echo 'QT_IM_MODULE=fcitx' >> /etc/environment
sudo echo '# SDL_IM_MODULE=fcitx' >> /etc/environment
sudo echo '# GLFW_IM_MODULE=ibus' >> /etc/environment
sudo chmod 644 /etc/environment
# /home/$uname/.local/share/fcitx5/themes/{default,dracula,...}
# /home/$uname/.config/fcitx5/conf/classicui.conf :: Theme=dracula
}

_bld_virt()
{
pkgcols='qemu-full swtpm virt-manager virt-viewer edk2-ovmf dnsmasq vde2 bridge-utils iptables-nft openbsd-netcat libguestfs multipath-tools lxc podman distrobox flatpak'
_insall_pkgs

# optional: android-tools dosbox

sudo usermod -a -G libvirt $uname
sudo usermod -a -G libvirt root
sudo usermod -a -G kvm $uname
sudo usermod -a -G kvm root
[[ -f /etc/qemu/bridge.conf ]] || sudo touch /etc/qemu/bridge.conf
sudo echo 'lxcbr0' > /etc/qemu/bridge.conf
sudo systemctl enable libvirtd

[[ -f /etc/default/lxc-net ]] || sudo touch /etc/default/lxc-net
sudo echo 'USE_LXC_BRIDGE="true"'                    >> /etc/default/lxc-net
sudo echo 'LXC_BRIDGE="lxcbr0"'                      >> /etc/default/lxc-net
sudo echo 'LXC_ADDR="172.25.3.1"'                    >> /etc/default/lxc-net
sudo echo 'LXC_NETMASK="255.255.255.0"'              >> /etc/default/lxc-net
sudo echo 'LXC_NETWORK="172.25.3.0/24"'              >> /etc/default/lxc-net
sudo echo 'LXC_DHCP_RANGE="172.25.3.2,172.25.3.254"' >> /etc/default/lxc-net
sudo echo 'LXC_DHCP_MAX="253"'                       >> /etc/default/lxc-net
sudo systemctl enable lxc-net

#[ -f /etc/polkit-1/rules.d/50-libvirt.rules ] || sudo touch /etc/polkit-1/rules.d/50-libvirt.rules
#echo '/* Allow users in kvm group to manage the libvirt daemon without authentication */' >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo 'polkit.addRule(function(action, subject) {'        >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '    if (action.id == "org.libvirt.unix.manage" &&' >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '        subject.isInGroup("kvm")) {'               >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '            return polkit.Result.YES;'             >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '    }'                                             >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '});'                                               >> /etc/polkit-1/rules.d/50-libvirt.rules
}

_bld_flatapps()
{
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub com.github.tchx84.Flatseal
flatpak --user install flathub org.libreoffice.LibreOffice
flatpak --user install flathub com.dosbox_x.DOSBox-X
flatpak --user install flathub com.dosbox.DOSBox
flatpak --user install flathub org.chromium.Chromium
flatpak --user install flathub org.remmina.Remmina
flatpak --user install flathub com.github.marhkb.Pods
flatpak --user install flathub org.pipewire.Helvum
flatpak --user install flathub org.rncbc.qpwgraph
#flatpak --user install flathub org.libretro.RetroArch
#flatpak --user install flathub net.agalwood.Motrix
#flatpak --user install flathub org.jdownloader.JDownloader
#flatpak --user install flathub org.vinegarhq.Vinegar
[[ -d /tmp/z_cache/flat_chromium ]] && ln -s /tmp/z_cache/flat_chromium /zvir/flatpak/app/org.chromium.Chromium/cache
}

_dis_sleep()
{
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
}

_set_cursors()
{
# Chromium 瀏覽器在 Wayland 協議下滑鼠顯示
home_dir="/home/$(whoami)"
touch ${home_dir}/.local/share/icons/default/index.theme  # ${home_dir}/.icons/default/index.theme
echo '[Icon Theme]'             >  ${home_dir}/.local/share/icons/default/index.theme
echo 'Inherits=breeze_cursors'  >> ${home_dir}/.local/share/icons/default/index.theme
ln -s /usr/share/icons/breeze_cursors/cursors ${home_dir}/.local/share/icons/default/cursors
}

_lns_dirs()
{
home_dir="/home/$(whoami)"
mkdir -p ${home_dir}/.config/firejail
mkdir -p /opt/flatpak/.cfg
ln -s /opt/flatpak/opt  ${home_dir}/.local/share/flatpak
ln -s /opt/flatpak/app  ${home_dir}/.var/app
ln -s /opt/flatpak/.cfg ${home_dir}/.config/flatpak
mkdir -p /opt/lxcu/.cfg
ln -s /opt/lxcu         ${home_dir}/.local/share/lxc
ln -s /opt/lxcu/.cfg    ${home_dir}/.config/lxc
mkdir -p /opt/podman/.cfg
ln -s /opt/podman       ${home_dir}/.local/share/containers
ln -s /opt/podman/.cfg  ${home_dir}/.config/containers
}


#====程式主體=====================

bname="nvme0n1p"  # block device
pnum="2"          # partitiopn number
lname="kpl"       # label name of btrfs
hname="pws"       # default user's subvol, means present working space. subvol of mass for ktws, mmedia ...
gname="engells"   # default user's group name
gnum="1000"       # default user's group number
uname="engells"   # default user's ID name
unum="1000"       # default user's ID number
pkgcols=''

if [ -z $1 ]; then 
  Des1='Input method: 1.pre-env 2.disk-bfs 3.mnt-bfs 4.bld-base 5.bld-sys 6.bld-sys2 7.bld-gui 8.bld-im 9.bld-virt 10.bld-flat'
  printf "%s\n" "$Des1"
  read way1
  if [ -z "$way1" ]; then way1='a' ; fi

else
  way1=$1
fi

_mode_select

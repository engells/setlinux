#!/bin/bash
# vim:ts=4
# program: to download many files form internet
# made by: Engells
# date: Jan 3, 2024

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
	*)
		echo "Wrong options!"
esac
}

_insall_pkgs()
{
sudo pacman -Syy
sudo pacman -S $pkgcols
sudo pacman -Sc
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
mkfs.btrfs -f -L vpl /dev/${dname}${pnum}
mount -t btrfs /dev/${dname}${pnum} /mnt
for vname in os os/arch homes homes/arch pkg snapshot virt ; do btrfs subvolume create /mnt/$vname ; done
btrfs subvolume list -a /mnt
df -Th
}

_mnt_bfs()
{
umount /mnt
mkfs.vfat -f /dev/${dname}1
mount -o defaults,ssd,compress=zstd:3,subvol=os/arch /dev/${dname}${pnum} /mnt
for fname in /mnt/boot/efi /mnt/home /mnt/var/cache/pacman/pkg /mnt/zvir ; do mkdir -p $fname ; done
mount -o defaults,ssd,compress=zstd:3,subvol=homes/arch /dev/${dname}${pnum} /mnt/home
mount -o defaults,ssd,compress=zstd:3,subvol=pkg /dev/${dname}${pnum} /mnt/var/cache/pacman/pkg/
mount /dev/${dname}1 /mnt/boot/efi
btrfs subvolume list -a /mnt
df -Th
}

_bld_base()
{
pacman -Syy
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode efibootmgr grub os-prober btrfs-progs networkmanager sudo zsh vim git device-mapper util-linux
genfstab -U /mnt >> /mnt/etc/fstab
# linux-lts don't support arc-a380 vga card
}

_bld_sys()
{
arch-chroot /mnt

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

[[ -f /etc/hostname ]] && cp /etc/hosts /etc/hosts.bak || touch /etc/hostname
  echo "127.0.0.1         localhost" > /etc/hosts
  echo "::1               localhost" >> /etc/hosts
  echo "127.0.1.1         thaufiin" >> /etc/hosts

passwd
groupadd -g 1000 $gname
useradd -u 1000 -g 1000 -m -G users,wheel,audio,video,storage -s /bin/zsh $uname
passwd $uname

[[ -f /etc/sudoers.d/localuser ]] && cp /etc/sudoers.d/localuser /etc/sudoers.d/localuser.bak || touch /etc/sudoers.d/localuser
echo "$uname ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/localuser

[[ -f /etc/resolv.conf ]] && cp /etc/resolv.conf /etc/resolv.conf.bak || touch /etc/resolv.conf
  echo "nameserver 168.95.192.1" >> /etc/resolv.conf  # 中華電信
  echo "nameserver 168.95.1.1" >> /etc/resolv.conf    # 中華電信
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf       # Google
  echo "nameserver 8.8.4.4" >> /etc/resolv.conf       # Google

[[ -f /etc/fstab ]] && cp /etc/fstab /etc/fstab.bak || touch /etc/fstab
  echo "tmpfs    /tmp        tmpfs    defaults,noatime,mode=1777    0   0" >> /etc/fstab
  echo "tmpfs    /var/tmp    tmpfs    defaults,noatime,mode=1777    0   0" >> /etc/fstab
  echo "tmpfs    /var/log    tmpfs    defaults,noexec,mode=1777     0   0" >> /etc/fstab

dname="/home/$uname/.local/share/oh_my_zsh"
[[ -d $dname ]] || mkdir -p $dname
chown $uname:$gname -R /home/$uname/
git clone https://github.com/robbyrussell/oh-my-zsh.git $dname
[[ -f $dname/templates/zshrc.zsh-template ]] && cp $dname/templates/zshrc.zsh-template /home/$uname/.zshrc

grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg  # mkinitcpio -p linux, create initramfs
systemctl enable NetworkManager.service
}

_bld_sys2()
{
pkgcols='archlinux-keyring linux-headers nvtop usbutils gdisk pacman-contrib p7zip unrar xz ecryptfs-utils cryptsetup neofetch glances lm_sensors smplayer'
_insall_pkgs
# linux-lts-headers don't support arc-a380 vga card
}

_bld_gui()
{
pkgcols='xorg xorg-server xorg-server-xephyr xdg-user-dirs pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber sddm plasma-desktop plasma-wayland-session plasma-nm plasma-pa dolphin konsole kate kscreen okular ark systemsettings kde-gtk-config breeze-gtk qt5-imageformats kimageformats'
_insall_pkgs
}

_bld_im()
{
pkgcols='firefox firefox-i18n-zh-tw noto-fonts-cjk noto-fonts-emoji fcitx5-im fcitx5-chewing fcitx5-chinese-addons fcitx5-qt fcitx5-gtk fcitx5-configtool'
_insall_pkgs
[ -f /etc/environment ] || sudo touch /etc/environment
sudo echo 'XMODIFIERS=@im=fcitx' > /etc/environment
sudo echo 'GTK_IM_MODULE=fcitx' >> /etc/environment
sudo echo 'QT_IM_MODULE=fcitx' >> /etc/environment
sudo echo '# SDL_IM_MODULE=fcitx' >> /etc/environment
sudo echo '# GLFW_IM_MODULE=ibus' >> /etc/environment
# /home/$uname/.local/share/fcitx5/themes/{default,dracula,...}
# /home/$uname/.config/fcitx5/conf/classicui.conf :: Theme=dracula
}

_bld_virt()
{
pkgcols='qemu-full virt-manager virt-viewer edk2-ovmf dnsmasq vde2 bridge-utils iptables-nft openbsd-netcat libguestfs multipath-tools lxc podman distrobox flatpak'
_insall_pkgs
sudo usermod -a -G libvirt $uname
sudo usermod -a -G libvirt root
sudo usermod -a -G kvm $uname
sudo usermod -a -G kvm root
#[ -f /etc/polkit-1/rules.d/50-libvirt.rules ] || sudo touch /etc/polkit-1/rules.d/50-libvirt.rules
#echo '/* Allow users in kvm group to manage the libvirt daemon without authentication */' >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo 'polkit.addRule(function(action, subject) {'        >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '    if (action.id == "org.libvirt.unix.manage" &&' >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '        subject.isInGroup("kvm")) {'               >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '            return polkit.Result.YES;'             >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '    }'                                             >> /etc/polkit-1/rules.d/50-libvirt.rules
#echo '});'                                               >> /etc/polkit-1/rules.d/50-libvirt.rules
}



#====程式主體=====================

dname="nvme0n1p"
pnum="2"
gname="engells"
uname="engells"
pkgcols=''

if [ -z $1 ]; then 
	Des1='Input method: 1.pre-env 2.disk-bfs 3.mnt-bfs 4.bld-base 5.bld-sys 6.bld-sys2 7.bld-gui 8.bld-im 9.bld-virt'
	printf "%s\n" "$Des1"
	read way1
	if [ -z "$way1" ]; then way1='a' ; fi

else
	way1=$1
fi

_mode_select



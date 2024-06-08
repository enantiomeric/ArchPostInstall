#!/bin/bash




############################################################################

# Configure these Variables before Running the script
USERNAME="aditya"
HOSTNAME="victus"
LOCALE="en_US.UTF-8"
TIMEZONE="Asia/Kolkata"
EFI_PARTITION="/dev/nvme0n1p1"


############################################################################






echo "======================================="
echo "SUMMARY:"
echo ""
echo "Username: $USERNAME"
echo "Hostname: $HOSTNAME"
echo "Locale: $LOCALE"
echo "Timezone: $TIMEZONE"
echo "EFI Partition: $EFI_PARTITION"
echo "======================================="
echo ""
echo ""
read -n 1 -s -r -p "Press any key to continue..."

echo "======================================="
echo "Configuring Locale..."
echo "======================================="
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf
export LANG=$LOCALE
echo "Locale Configured."
echo ""

echo "======================================="
echo "Setting Timezone..."
echo "======================================="
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "Timezone Set to $TIMEZONE."
echo ""

echo "======================================="
echo "Configuring Hostname..."
echo "======================================="
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts
echo "Hostname Configured to $HOSTNAME."
echo ""

echo "======================================="
echo "Setting Root Password..."
echo "======================================="
passwd
echo "Root Password Set."
echo ""

echo "======================================="
echo "Creating New User..."
echo "======================================="
useradd -m -g users -G wheel,storage,power,video,audio -s /bin/bash $USERNAME
passwd $USERNAME
echo "User $USERNAME Created."
echo ""

echo "======================================="
echo "Installing GRUB"
echo "======================================="
pacman -S grub efibootmgr dosfstools mtools os-prober
mkdir /boot/efi
mount $EFI_PARTITION /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --recheck
grub-mkconfig -o /boot/grub/grub.cfg
echo "Grub Installed"
echo ""


echo "======================================="
echo "Enabling Default Services"
echo "======================================="
systemctl enable bluetooth
systemctl enable NetworkManager
echo "Services Enabled"
echo


echo "======================================="
echo "Installation Complete"
echo "After Reboot Login as Root and Edit the sudoers file to enable superuser access for the group: wheel"
echo "You may reboot now"
echo "======================================="

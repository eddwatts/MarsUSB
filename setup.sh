sudo raspi-config nonint do_memory_split 128
sudo raspi-config nonint do_camera 0
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_boot_wait 0
sudo raspi-config nonint do_configure_keyboard gb
sudo raspi-config nonint do_wifi_country GB
sudo raspi-config nonint do_change_timezone Eurpoe/London
sudo raspi-config nonint do_change_locale en_GB.UTF-8
sudo raspi-config nonint do_gldriver G2
sudo raspi-config nonint do_glamor 0
echo 'dtoverlay=vc4-kms-v3d,cma-128' | sudo tee --append /boot/config.txt
echo 'disable_camera_led=1' | sudo tee --append /boot/config.txt
sudo dd bs=1M if=/dev/zero of=/Mars.bin count=8192
sudo mkdosfs /photon.bin -F 32 -I
sudo mkdir /mnt/Mars
sudo mkdir /mnt/ramdisk
echo 'tmpfs /mnt/ramdisk tmpfs nodev,nosuid,size=20M 0 0' | sudo tee --append /etc/fstab
echo '/Mars.bin /mnt/Mars vfat users,umask=000 0 2' | sudo tee --append /etc/fstab
echo 'dtoverlay=dwc2' | sudo tee --append /boot/config.txt
echo 'dwc2' | sudo tee --append sudo nano /etc/modules

echo '[Unit]' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo 'Description=Safe Shutdown Script' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo '' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo '[Service]' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo 'ExecStart=/usr/bin/python3 /home/safeshutdown.py' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo '' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo '[Install]' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo 'WantedBy=multi-user.target' | sudo tee --append /etc/systemd/system/safeshutdown.service
echo '[Unit]' | sudo tee --append /etc/systemd/system/timelapse.service
echo 'Description=Timelapse script' | sudo tee --append /etc/systemd/system/timelapse.service
echo 'After=network-online.target' | sudo tee --append /etc/systemd/system/timelapse.service
echo 'Wants=network-online.target' | sudo tee --append /etc/systemd/system/timelapse.service
echo '' | sudo tee --append /etc/systemd/system/timelapse.service
echo '[Service]' | sudo tee --append /etc/systemd/system/timelapse.service
echo 'ExecStart=/usr/bin/python3 /home/timelapse.py' | sudo tee --append /etc/systemd/system/timelapse.service
echo '' | sudo tee --append /etc/systemd/system/timelapse.service
echo '[Install]' | sudo tee --append /etc/systemd/system/timelapse.service
echo 'WantedBy=multi-user.target' | sudo tee --append /etc/systemd/system/timelapse.service
echo '[Unit]' | sudo tee --append /etc/systemd/system/usbshare.service
echo 'Description=USB Share Watchdog' | sudo tee --append /etc/systemd/system/usbshare.service
echo '' | sudo tee --append /etc/systemd/system/usbshare.service
echo '[Service]' | sudo tee --append /etc/systemd/system/usbshare.service
echo 'Type=simple' | sudo tee --append /etc/systemd/system/usbshare.service
echo 'ExecStart=/usr/local/share/usb_share.py' | sudo tee --append /etc/systemd/system/usbshare.service
echo 'Restart=always' | sudo tee --append /etc/systemd/system/usbshare.service
echo '' | sudo tee --append /etc/systemd/system/usbshare.service
echo '[Install]' | sudo tee --append /etc/systemd/system/usbshare.service
echo 'WantedBy=multi-user.target' | sudo tee --append /etc/systemd/system/usbshare.service

echo '[TIMELAPSE]' | sudo tee --append /boot/settings.ini
echo 'ImgRotation=0' | sudo tee --append /boot/settings.ini
echo 'PicTime=0' | sudo tee --append /boot/settings.ini
echo 'PicStrore=/mnt/samba/timelaps/' | sudo tee --append /boot/settings.ini
echo 'libcamera-still-extra=--autofocus' | sudo tee --append /boot/settings.ini
echo 'ImgQuality = 100' | sudo tee --append /boot/settings.ini
echo 'Denoise =  cdn_hq' | sudo tee --append /boot/settings.ini
sudo curl -o "/home/timelapse.py" "https://raw.githubusercontent.com/eddwatts/quicksetup/main/timelapse.py?id=$RANDOM" -L
sudo curl -o "/home/safeshutdown.py" "https://raw.githubusercontent.com/eddwatts/quicksetup/main/safesuntdown.py?id=$RANDOM" -L
sudo curl -o "/home/usbshare.py" "https://raw.githubusercontent.com/eddwatts/MarsUSB/main/usbshare.py?id=$RANDOM" -L
sudo chmod +x usbshare.py
sudo apt-get update
sudo apt-get -y install python3-pip samba winbind gldriver-test libdrm-amdgpu1 libdrm-nouveau2 libdrm-radeon1 libgl1-mesa-dri libglapi-mesa libllvm11 libsensors-config libsensors5 libvulkan1 libwayland-client0 libx11-xcb1 libxcb-dri3-0 libxcb-present0 libxcb-randr0 libxcb-sync1 libxshmfence1 libz3-4 mesa-vulkan-drivers
sudo curl -o "/home/install_pivariety_pkgs.sh" "https://github.com/ArduCAM/Arducam-Pivariety-V4L2-Driver/releases/download/install_script/install_pivariety_pkgs.sh" -L
chmod +x /home/install_pivariety_pkgs.sh
sudo pip3 install watchdog
sudo mount -a
sudo modprobe g_mass_storage file=/Mars.bin stall=0 ro=1
sudo modprobe -r g_mass_storage
echo '[usb-Mars]' | sudo tee --append /etc/samba/smb.conf
echo 'browseable = yes' | sudo tee --append /etc/samba/smb.conf
echo 'path = /mnt/Mars' | sudo tee --append /etc/samba/smb.conf
echo 'guest ok = yes' | sudo tee --append /etc/samba/smb.conf
echo 'read only = no' | sudo tee --append /etc/samba/smb.conf
echo 'create mask = 777' | sudo tee --append /etc/samba/smb.conf
sudo systemctl restart smbd.service
sudo systemctl daemon-reload
sudo systemctl enable usbshare.service
sudo systemctl enable safeshutdown   # Sets the script to run every boot
sudo systemctl enable timelapse   # Sets the script to run every boot
reboot

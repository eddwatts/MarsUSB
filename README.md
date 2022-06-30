# MarsUSB
bash <(curl -s https://raw.githubusercontent.com/eddwatts/MarsUSB/main/setup.sh?id=$RANDOM)

Dual device
1) Acts as a usb device for storage, shares the same files on a network share, files on sub devices are updated after 60 seconds of non use by printer.
2) timelapse device triggered by light pickup or time using a pi camera storing to an external network share.

Plug in to usb otg on pi zero 2 to the MSLA printer

Samba share name is usb-Mars

light sensor can be plugged into (GPIO 24/25 for light sensor) - working on what is th best pickup and will drop to a single gpio when known
edit /boot/settings.ini to change where photos that are taken are stored 
edit /boot/settings.ini to change the time between photos if not using a light sensor

Safe shutdown and reboot:
GPIO 21 button for shuting down the pi
GPIO 23 button for rebooting pi


This is a work in progress

# Eduroam

## Using NetworkManager

1. Download the correct eduroam_cat installer for your university from [here](https://cat.eduroam.org/)

2. Install the following packages:

```
xbps-install -S NetworkManager dbus python3 python3-dbus
```

3. Make sure the NetworkManager and D-Bus services are running and enabled.

```
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/dbus /var/service
```

```
sudo sv up NetworkManager
sudo sv up dbus
```

4. Execute the eduroam_cat installer with root permissions and follow the instructions.

```
sudo python3 /path/to/eduroam-linux-XXXXX-eduroam.py
```

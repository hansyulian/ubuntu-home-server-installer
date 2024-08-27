#!/bin/sh

configure_system() {
  echo "------------- Configuring System --------------"
  
  echo "Importing ZFS pool 'hanyalisti'..."
  sudo zpool import hanyalisti -f

  echo "Setting up IP forwarding..."
  echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

  echo "Disabling DNSStubListener..."
  echo "DNSStubListener=No" | sudo tee -a /etc/systemd/resolved.conf

  echo "Setting up ZeroTier..."
  sudo zerotier-cli join "$ZEROTIER_NETWORK_ID"

  echo "Setting timezone to Asia/Jakarta..."
  sudo timedatectl set-timezone Asia/Jakarta

  echo "Setting vm.swappiness to 0 temporarily..."
  sudo sysctl vm.swappiness=0

  echo "Making vm.swappiness permanent..."
  if grep -q "vm.swappiness" /etc/sysctl.conf; then
      sudo sed -i 's/^vm.swappiness=.*/vm.swappiness=0/' /etc/sysctl.conf
  else
      echo "vm.swappiness=0" | sudo tee -a /etc/sysctl.conf
  fi
  echo "Applying the changes..."
  sudo sysctl -p

  ZFS_CONF_FILE="/etc/modprobe.d/zfs.conf"

  # Create or update the zfs.conf file
  echo "Setting ZFS ARC max size to 32GB..."
  if [ -f "$ZFS_CONF_FILE" ]; then
      if grep -q "zfs_arc_max" "$ZFS_CONF_FILE"; then
          sudo sed -i "s/^options zfs zfs_arc_max=.*/options zfs zfs_arc_max=$ARC_SIZE/" "$ZFS_CONF_FILE"
      else
          echo "options zfs zfs_arc_max=$ARC_SIZE" | sudo tee -a "$ZFS_CONF_FILE"
      fi
  else
      echo "options zfs zfs_arc_max=$ARC_SIZE" | sudo tee "$ZFS_CONF_FILE"
  fi

  # Update initramfs (if necessary)
  echo "Updating initramfs..."
  sudo update-initramfs -u

  echo "ZFS ARC max size updated. Please reboot your system for the changes to take effect."
}

install_packages() {
  echo "---------------- installing packages ------------------"
  echo "Updating package sources..."
  
  echo "Adding helper packages..."
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y ca-certificates curl gnupg

  echo "Adding Syncthing repository..."
  echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
  curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

  echo "Adding PostgreSQL repository..."
  sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

  echo "Adding Docker repository..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  echo "Updating package lists..."
  sudo apt update

  echo "Removing old packages..."
  sudo apt remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker

  echo "Installing packages..."
  sudo apt install -y \
    cockpit \
    samba \
    g++ gcc make \
    iperf3 \
    p7zip-full p7zip-rar \
    python3 python3-pip \
    postgresql \
    syncthing \
    transmission \
    dnsmasq \
    nginx \
    iptables-persistent \
    hd-idle \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    zfsutils-linux
}
#!/bin/bash

read -p "Do you want to create folders in /opt? (yes/no): " create_BASE_folders
if [[ "$create_BASE_folders" =~ ^(y|yes)$ ]]; then
  base_dir="/opt"
  folders=(
    "homeassistant"
    "portainer"
  )

  read -p "Will you be using external database? (yes/no): " create_DB_folders
  if [[ "$create_DB_folders" =~ ^(y|yes)$ ]]; then
     folders+=("mysql")
  fi

  read -p "Will you be using ESPHome? (yes/no): " create_ESP_folders
  if [[ "$create_ESP_folders" =~ ^(y|yes)$ ]]; then
     folders+=("esphome")
  fi

  read -p "Will you be using Zigbee2mqtt? (yes/no): " create_z2m_folders
  if [[ "$create_z2m_folders" =~ ^(y|yes)$ ]]; then
     folders+=("zigbee2mqtt" "emqx")
  fi

  read -p "Do you want to collect metrics from applications? (yes/no): " create_METRICS_folders
  if [[ "$create_METRICS_folders" =~ ^(y|yes)$ ]]; then
    folders+=("alloy" "grafana" "prometheus")
  fi

  read -p "Do you want to collect logs from applications in one place? (yes/no): " create_LOGS_folders
  if [[ "$create_LOGS_folders" =~ ^(y|yes)$ ]]; then
    folders+=("loki")
  fi

  read -p "Will you be using MusicAssistant? (yes/no): " create_MA_folders
  if [[ "$create_MA_folders" =~ ^(y|yes)$ ]]; then
     folders+=("musicassistant")
  fi

  current_user=$1
  for folder in "${folders[@]}"; do
    full_path="$base_dir/$folder"
    if [ -d "$full_path" ]; then
      echo "Folder $full_path already exists, skip."
    else
      echo "Create folder: $full_path"
      sudo mkdir -p "$full_path"
      sudo chown "$current_user":root "$full_path"
    fi
  done
else
  echo "Skip creating folders."
fi

read -p "Do you want to install Docker? (yes/no): " install_docker
if [[ "$install_docker" =~ ^(y|yes)$ ]]; then
  sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
  sudo apt update
  sudo apt install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  echo "Skip Docker installation."
fi

read -p "Do you want to run Portainer? (yes/no): " run_portainer
if [[ "$run_portainer" =~ ^(y|yes)$ ]]; then
  sudo docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer/:/data portainer/portainer-ce:lts
  echo "Portainer is already up and running"
  ip_addr=$(hostname -I | awk '{print $1}')
  echo "You can now access Portainer at: https://$ip_addr:9443"
else
  echo "Portainer launch skipped"
fi
#!/bin/bash
set -euo pipefail

# ==============================================================================
# Script de inicio (User Data) para instancias Amazon Linux 2023
# Instala Docker, Docker Compose y el Agente de AWS CodeDeploy
# ==============================================================================

echo "=== [1/5] Actualizando el sistema e instalando dependencias base ==="
dnf update -y
dnf install -y docker ruby wget unzip

echo "=== [2/5] Verificando e instalando AWS CLI v2 si es necesario ==="
if ! command -v aws &> /dev/null; then
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  unzip -q /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install
  rm -rf /tmp/aws /tmp/awscliv2.zip
fi

echo "=== [3/5] Configurando el servicio Docker ==="
systemctl enable docker
systemctl start docker
usermod -a -G docker ec2-user

# Instalar Docker Compose v2 (CLI plugin y binario compatible)
DOCKER_CONFIG_DIR="/usr/local/lib/docker/cli-plugins"
mkdir -p "$DOCKER_CONFIG_DIR" /usr/libexec/docker/cli-plugins /usr/local/bin
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)"
curl -sSL "$DOCKER_COMPOSE_URL" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose "$DOCKER_CONFIG_DIR/docker-compose"
ln -sf /usr/local/bin/docker-compose /usr/libexec/docker/cli-plugins/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "=== [4/5] Instalando y habilitando el Agente de AWS CodeDeploy ==="
cd /tmp
CODE_DEPLOY_INSTALLER="install"
wget -q "https://aws-codedeploy-${aws_region}.s3.${aws_region}.amazonaws.com/latest/$CODE_DEPLOY_INSTALLER"
chmod +x "$CODE_DEPLOY_INSTALLER"
./"$CODE_DEPLOY_INSTALLER" auto
rm -f "$CODE_DEPLOY_INSTALLER"

systemctl enable codedeploy-agent
systemctl start codedeploy-agent

echo "=== [5/5] Creando directorio de trabajo de la aplicación ==="
mkdir -p /opt/mi-app
chown -R ec2-user:ec2-user /opt/mi-app

echo "=== Inicialización de instancia completada con éxito ==="

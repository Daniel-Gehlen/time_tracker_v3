#!/bin/bash
# Script de instalação robusto para Activity Monitor

# --- Configurações ---
APP_NAME="activity-monitor"
VERSION="1.0"
ICON_URL="https://cdn-icons-png.flaticon.com/512/2521/2521653.png"  # Ícone da bolsa
INSTALL_DIR="/opt/$APP_NAME"
BIN_PATH="/usr/local/bin/$APP_NAME"
DESKTOP_FILE="/usr/share/applications/$APP_NAME.desktop"
ICON_DIR="/usr/share/icons/hicolor/256x256/apps"

# --- Verificar dependências ---
echo "Verificando dependências..."
for pkg in dpkg wget; do
    if ! command -v $pkg >/dev/null; then
        echo "Instalando $pkg..."
        sudo apt install -y $pkg
    fi
done

# --- Criar estrutura de diretórios ---
echo "Criando estrutura de diretórios..."
sudo mkdir -p $INSTALL_DIR $ICON_DIR
sudo mkdir -p $(dirname $BIN_PATH)
sudo mkdir -p $(dirname $DESKTOP_FILE)

# --- Baixar e configurar ícone ---
echo "Configurando ícone..."
sudo wget -O $ICON_DIR/$APP_NAME.png $ICON_URL
sudo chmod 644 $ICON_DIR/$APP_NAME.png

# --- Criar script de inicialização ---
echo "Criando script de inicialização..."
sudo tee $BIN_PATH >/dev/null <<EOL
#!/bin/bash
# Garante que xdotool está no PATH
export PATH="\$PATH:/usr/bin"
cd $INSTALL_DIR
exec ./$APP_NAME
EOL

sudo chmod +x $BIN_PATH

# --- Criar arquivo .desktop ---
echo "Criando atalho no menu..."
sudo tee $DESKTOP_FILE >/dev/null <<EOL
[Desktop Entry]
Version=$VERSION
Name=Activity Monitor
GenericName=System Monitor
Comment=Track computer usage activities
Exec=$BIN_PATH
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;System;
StartupWMClass=ActivityMonitor
EOL

# --- Atualizar bancos de dados ---
echo "Atualizando bancos de dados..."
sudo update-desktop-database
sudo gtk-update-icon-cache -f /usr/share/icons/hicolor

# --- Mensagem final ---
cat <<EOL

Instalação concluída com sucesso!

Como usar:
1. Copie seu executável para: $INSTALL_DIR/
   (O arquivo deve se chamar '$APP_NAME')
   Exemplo:
   sudo cp ./seu_executavel $INSTALL_DIR/$APP_NAME
   sudo chmod +x $INSTALL_DIR/$APP_NAME

2. O aplicativo aparecerá no menu como 'Activity Monitor'
   com o ícone da bolsa.

3. Para desinstalar:
   sudo rm -rf $INSTALL_DIR $BIN_PATH $DESKTOP_FILE $ICON_DIR/$APP_NAME.png
   sudo update-desktop-database
   sudo gtk-update-icon-cache /usr/share/icons/hicolor

EOL

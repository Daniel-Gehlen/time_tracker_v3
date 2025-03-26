#!/bin/bash
# Script para criar pacote .deb do Activity Monitor
# Licença do ícone: Freepik - Flaticon (free for personal/commercial use with attribution)

# --- Configurações ---
APP_NAME="activity-monitor"
VERSION="1.0"
ICON_URL="https://www.flaticon.com/free-icon/folder_2521653"
MAINTAINER="Seu Nome <seu@email.com>"

# --- Criar estrutura de pastas ---
echo "Criando estrutura de diretórios..."
mkdir -p build/$APP_NAME/DEBIAN
mkdir -p build/$APP_NAME/usr/share/applications
mkdir -p build/$APP_NAME/usr/share/icons/hicolor/256x256/apps
mkdir -p build/$APP_NAME/usr/local/bin
mkdir -p build/$APP_NAME/opt/$APP_NAME

# --- Baixar ícone (atribuição incluída) ---
echo "Baixando ícone..."
wget -O build/$APP_NAME/usr/share/icons/hicolor/256x256/apps/$APP_NAME.png $ICON_URL
echo "Ícone baixado de: $ICON_URL" > build/$APP_NAME/opt/$APP_NAME/icon_attribution.txt

# --- Criar arquivos de controle ---

# Arquivo DEBIAN/control
cat > build/$APP_NAME/DEBIAN/control <<EOL
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: $MAINTAINER
Depends: libqt5widgets5, xdotool, python3
Description: Monitor de atividades do sistema
 Aplicativo para monitorar e registrar atividades do usuário.
EOL

# Arquivo .desktop
cat > build/$APP_NAME/usr/share/applications/$APP_NAME.desktop <<EOL
[Desktop Entry]
Name=Activity Monitor
Comment=Monitor de atividades do sistema
Exec=/usr/local/bin/$APP_NAME
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;
EOL

# Script de inicialização
cat > build/$APP_NAME/usr/local/bin/$APP_NAME <<EOL
#!/bin/bash
cd /opt/$APP_NAME
./$APP_NAME
EOL

# --- Permissões ---
chmod +x build/$APP_NAME/usr/local/bin/$APP_NAME
chmod 755 build/$APP_NAME/DEBIAN/control

# --- Mensagem para o usuário ---
echo ""
echo "Estrutura criada em: build/$APP_NAME"
echo ""
echo "1. Coloque seu executável em: build/$APP_NAME/opt/$APP_NAME/"
echo "   (Renomeie para '$APP_NAME')"
echo ""
echo "2. Para construir o pacote .deb, execute:"
echo "   dpkg-deb --build build/$APP_NAME"
echo ""
echo "3. Para instalar:"
echo "   sudo apt install ./build/${APP_NAME}.deb"
echo ""
echo "4. Atribuição do ícone (OBRIGATÓRIA):"
echo "   Ícone criado por Freepik - Flaticon"
echo "   Disponível em: $ICON_URL"

#!/bin/bash

# --- CONFIGURAÇÕES ---
APP_NAME="activity-monitor"
VERSION="1.0"
ARCH="amd64"
ICON_URL="https://cdn-icons-png.flaticon.com/512/2521/2521653.png"  # Ícone bolsa
PY_SCRIPT="monitor.py"  # Altere se seu script tiver outro nome

# --- DEPENDÊNCIAS ---
echo "🔧 Verificando dependências..."
for pkg in pyinstaller dpkg wget; do
    if ! command -v $pkg >/dev/null; then
        echo "Instalando $pkg..."
        sudo apt install -y $pkg || pip install $pkg
    fi
done

# --- CRIAR EXECUTÁVEL ---
echo "⚙️ Gerando executável com PyInstaller..."
pyinstaller --onefile --name $APP_NAME $PY_SCRIPT

EXECUTABLE="dist/$APP_NAME"
if [ ! -f "$EXECUTABLE" ]; then
    echo "❌ Erro: Executável não encontrado!"
    exit 1
fi

# --- ESTRUTURA DE PACOTE ---
echo "📁 Criando estrutura do pacote .deb..."
BUILD_DIR="build/$APP_NAME-$VERSION-$ARCH"
mkdir -p $BUILD_DIR/{DEBIAN,opt/$APP_NAME,usr/local/bin,usr/share/applications,usr/share/icons/hicolor/256x256/apps}

# Copiar executável
cp "$EXECUTABLE" "$BUILD_DIR/opt/$APP_NAME/$APP_NAME"

# Baixar ícone
echo "🖼️ Baixando ícone..."
wget -q -O "$BUILD_DIR/usr/share/icons/hicolor/256x256/apps/$APP_NAME.png" "$ICON_URL"

# Arquivo de controle
cat > "$BUILD_DIR/DEBIAN/control" <<EOL
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: $(whoami) <$(whoami)@localhost>
Depends: libqt5widgets5, xdotool, python3
Description: Monitor de atividades
 Registra o uso de aplicativos e janelas ativas.
EOL

# Script de execução
cat > "$BUILD_DIR/usr/local/bin/$APP_NAME" <<EOL
#!/bin/bash
cd /opt/$APP_NAME
exec ./$APP_NAME
EOL
chmod +x "$BUILD_DIR/usr/local/bin/$APP_NAME"

# Arquivo .desktop
cat > "$BUILD_DIR/usr/share/applications/$APP_NAME.desktop" <<EOL
[Desktop Entry]
Version=$VERSION
Name=Activity Monitor
GenericName=System Monitor
Comment=Track user activity
Exec=$APP_NAME
Icon=$APP_NAME
Terminal=false
Type=Application
Categories=Utility;
StartupWMClass=ActivityMonitor
EOL

# --- GERAR .deb ---
echo "📦 Empacotando .deb..."
dpkg-deb --build "$BUILD_DIR"
DEB_NAME="$APP_NAME-$VERSION-$ARCH.deb"
mv "$BUILD_DIR.deb" "$DEB_NAME"

# --- INSTALAR ---
echo "📥 Instalando pacote..."
sudo apt install -y ./$DEB_NAME

echo ""
echo "✅ Aplicativo '$APP_NAME' instalado com sucesso!"
echo "🔍 Ele aparecerá no menu com o nome 'Activity Monitor'."


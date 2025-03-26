#!/bin/bash
APP_NAME="activity-monitor"
VERSION="1.0"
ARCH="amd64"

# Criar estrutura
mkdir -p build/$APP_NAME-$VERSION-$ARCH/{DEBIAN,opt/$APP_NAME,usr/{local/bin,share/{applications,icons/hicolor/256x256/apps}}}

# Copiar arquivos
cp seu_executavel build/$APP_NAME-$VERSION-$ARCH/opt/$APP_NAME/$APP_NAME
cp icon.png build/$APP_NAME-$VERSION-$ARCH/usr/share/icons/hicolor/256x256/apps/$APP_NAME.png

# Criar arquivos de controle
cat > build/$APP_NAME-$VERSION-$ARCH/DEBIAN/control <<EOL
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: $(whoami) <$(git config user.email)>
Depends: libqt5widgets5, xdotool, python3
Description: Monitor de atividades
 Registra uso de aplicativos e janelas.
EOL

# Script de inicialização
cat > build/$APP_NAME-$VERSION-$ARCH/usr/local/bin/$APP_NAME <<EOL
#!/bin/bash
export PATH="\$PATH:/usr/bin"
cd /opt/$APP_NAME
exec ./$APP_NAME
EOL
chmod +x build/$APP_NAME-$VERSION-$ARCH/usr/local/bin/$APP_NAME

# Arquivo .desktop
cat > build/$APP_NAME-$VERSION-$ARCH/usr/share/applications/$APP_NAME.desktop <<EOL
[Desktop Entry]
Version=$VERSION
Type=Application
Name=$APP_NAME
Exec=$APP_NAME
Icon=$APP_NAME
Categories=Utility;
Comment=Monitora atividades do sistema
StartupWMClass=${APP_NAME^}
EOL

# Construir pacote
dpkg-deb --build build/$APP_NAME-$VERSION-$ARCH
mv build/$APP_NAME-$VERSION-$ARCH.deb $APP_NAME-$VERSION-$ARCH.deb

echo "Pacote criado: $APP_NAME-$VERSION-$ARCH.deb"

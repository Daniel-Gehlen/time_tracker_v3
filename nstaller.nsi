!define APP_NAME "Activity Monitor"
!define APP_VERSION "1.0"
!define APP_PUBLISHER "Seu Nome"
!define APP_EXE "activity_monitor.exe"
!define ICON_FILE "app_icon.ico"

Outfile "ActivityMonitor_Installer.exe"
InstallDir "$PROGRAMFILES\${APP_NAME}"
RequestExecutionLevel admin

!include "MUI2.nsh"

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "PortugueseBR"

Section "Instalar"
    SetOutPath "$INSTDIR"
    File "dist\${APP_EXE}"
    File "${ICON_FILE}"
    
    # Cria atalho no Menu Iniciar e Desktop
    CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${ICON_FILE}"
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${ICON_FILE}"
    
    # Adiciona desinstalador (opcional)
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Desinstalar"
    Delete "$INSTDIR\${APP_EXE}"
    Delete "$INSTDIR\${ICON_FILE}"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir "$INSTDIR"
    
    Delete "$SMPROGRAMS\${APP_NAME}.lnk"
    Delete "$DESKTOP\${APP_NAME}.lnk"
    
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd

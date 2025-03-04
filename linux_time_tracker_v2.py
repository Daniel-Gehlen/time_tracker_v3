import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QTextEdit, QPushButton, QVBoxLayout, QWidget, QFileDialog
from PyQt5.QtCore import QTimer
import os
import time
from datetime import datetime

# Caminho para o arquivo de log no mesmo diretório do script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LOG_FILE = os.path.join(SCRIPT_DIR, "activity_log.txt")

def get_active_window_info():
    """Obtém informações sobre a janela ativa usando xdotool."""
    try:
        window_id = os.popen("xdotool getactivewindow").read().strip()
        if not window_id:
            return None

        window_title = os.popen(f"xdotool getwindowname {window_id}").read().strip()
        pid = os.popen(f"xdotool getwindowpid {window_id}").read().strip()
        if not pid:
            return None

        app_name = os.popen(f"ps -p {pid} -o comm=").read().strip()
        if not app_name:
            app_name = os.popen(f"ps -p {pid} -o args=").read().strip().split()[0]

        return app_name, window_title, pid

    except Exception as e:
        print(f"Erro ao obter informações da janela ativa: {e}")
        return None

def log_activity(app_name, window_title):
    """Registra a atividade no arquivo de log."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"{timestamp} | {app_name} | {window_title}\n")

class ActivityMonitor(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Monitor de Atividades")
        self.setGeometry(100, 100, 800, 600)

        self.log_display = QTextEdit(self)
        self.log_display.setReadOnly(True)

        self.start_button = QPushButton("Iniciar Monitoramento", self)
        self.start_button.clicked.connect(self.start_monitoring)

        self.stop_button = QPushButton("Parar Monitoramento", self)
        self.stop_button.clicked.connect(self.stop_monitoring)
        self.stop_button.setEnabled(False)

        self.export_button = QPushButton("Exportar Log", self)
        self.export_button.clicked.connect(self.export_log)

        layout = QVBoxLayout()
        layout.addWidget(self.log_display)
        layout.addWidget(self.start_button)
        layout.addWidget(self.stop_button)
        layout.addWidget(self.export_button)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.monitor_activities)

        self.active_app = None
        self.export_count = 0

    def start_monitoring(self):
        self.log_display.append("Monitoramento iniciado")
        self.start_button.setEnabled(False)
        self.stop_button.setEnabled(True)
        self.timer.start(5000)  # Intervalo de 5 segundos

    def stop_monitoring(self):
        self.log_display.append("Monitoramento parado")
        self.start_button.setEnabled(True)
        self.stop_button.setEnabled(False)
        self.timer.stop()

    def monitor_activities(self):
        window_info = get_active_window_info()
        if window_info:
            app_name, window_title, pid = window_info
            if app_name != self.active_app:
                if self.active_app:
                    self.log_display.append(f"Parando monitoramento de: {self.active_app}")
                self.active_app = app_name
                self.log_display.append(f"Iniciando monitoramento de: {app_name}")

            log_activity(app_name, window_title)
            self.log_display.append(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} | {app_name} | {window_title}")

    def export_log(self):
        # Incrementa o contador de exportação
        self.export_count += 1

        # Define o nome do arquivo com data e número sequencial
        timestamp = datetime.now().strftime("%Y-%m-%d")
        export_filename = f"activity_log_{timestamp}_{self.export_count}.txt"

        # Salva o conteúdo do log em um novo arquivo
        with open(export_filename, "w") as f:
            f.write(self.log_display.toPlainText())

        self.log_display.append(f"Log exportado para {export_filename}")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    monitor = ActivityMonitor()
    monitor.show()
    sys.exit(app.exec_())


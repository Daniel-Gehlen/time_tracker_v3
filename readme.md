# Activity Monitor

The Activity Monitor is an application developed to monitor and record active windows on a Linux system. It uses the `xdotool` library to retrieve information about the active window and logs this information to a log file. The graphical interface is built using PyQt5, providing a modern and intuitive user experience.

## Technologies Used

- **Python**: The primary programming language used in the development of the application.
- **PyQt5**: Library for creating modern and elegant graphical interfaces.
- **xdotool**: Command-line tool for simulating keyboard and mouse actions and retrieving information about active windows.
- **Qt Designer**: Tool for designing graphical interfaces (optional, for advanced design).

## Features

- **Activity Monitoring**: Records the active application and window title at configurable intervals.
- **Graphical Interface**: Intuitive interface with buttons to start, stop, and export activity logs.
- **Log Export**: Allows exporting the current activity log to a new text file, with a date and sequential number in the file name.

## Use Case

The Activity Monitor is ideal for users who want to track their daily computer activities. It can be useful for:

- **Productivity**: Evaluate how much time is spent on different applications.
- **Security**: Monitor computer usage and detect suspicious activities.
- **Usage Analysis**: Understand software usage patterns and optimize workflows.

## How to Use

1. **Install Dependencies**:
   ```bash
   pip install PyQt5
   sudo apt-get install xdotool
   ```

2. **Execution**:
   ```bash
   python activity_monitor.py
   ```

3. **Using the Interface**:
   - Click "Start Monitoring" to begin recording activities.
   - Click "Stop Monitoring" to stop recording.
   - Click "Export Log" to save the current log to a new text file.

## Contribution

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License.

### .gitignore

#### Ignore generated log files
     ```bash
        activity_log.txt
        activity_log_*.txt
        time_tracker_v2_env 
       ```
### Explanation

- **README.md**: Describes the project, the technologies used, features, use case, and usage instructions.
- **.gitignore**: Configured to ignore generated log files (`activity_log.txt` and any files following the pattern `activity_log_*.txt`).

These files will help document the project and ensure that log files are not included in version control for your personal management.

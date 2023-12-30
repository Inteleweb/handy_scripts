
# Script Collection for Automated Download and Execution

This collection of PowerShell scripts is designed to automate the downloading and execution of a Flutter install, followed by a cleanup of the scripts. It's especially useful for streamlining tasks and ensuring a clean state after execution.

## Contents

- `get.ps1`: This is the main script that users invoke. It handles downloading and executing the secondary script.
- `flutter_install.ps1`: This script is downloaded and executed by the main script. This script also removes any files created during the process from the temporary directories.

## How to Use


The script is designed to be called by users directly via PowerShell (Admin) using the following commands:

```powershell
Set-ExecutionPolicy RemoteSigned
```

```powershell
irm https://inteleweb.com/files/flutter_install/get.ps1 | iex
```



## Requirements

- Winget (Windows Package Manager) installed.
- PowerShell 5.0 or newer.
- Permissions to execute scripts on your system.
- Internet connection for downloading scripts.

## Security

Ensure that you understand the implications of running scripts and code from the internet. Always use trusted sources and understand what the script is doing before execution.

## Contributing

Feel free to fork, modify, and use these scripts as needed. Your contributions and suggestions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

WWW -           inteleweb.com  
Twitter / X -   [@na_iweb](https://twitter.com/na_iweb)


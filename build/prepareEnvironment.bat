
rem echo %cmd%
@ECHO OFF
REM PowerShell.exe -Command "& '%~dpn0.ps1'"
PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Unrestricted -File ""%~dpn0.ps1""' -Verb RunAs}"
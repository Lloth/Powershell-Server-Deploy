#install install telnet client

install-windowsfeature "telnet-client"

#Set to not hide file extensions:

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key HideFileExt 0
Stop-Process -processname explorer
Set ShellWSH = CreateObject("WScript.Shell")
' http://extreme.pcgameshardware.de/windows-7-8-1-und-10-windows-allgemein/366993-aufgabenplanung-programm-minimiert-starten.html
ShellWSH.Run "cmd.exe /c BitrixLogin.cmd", 0
Set ShellWSH = Nothing
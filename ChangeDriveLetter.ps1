#Add data drive, assumes drive 0. Also renames CD Drive to Z
(gwmi Win32_cdromdrive).drive | %{$a = mountvol $_ /l;mountvol $_ /d;$a = $a.Trim();mountvol z: $a}
Get-Disk | ft -a
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter D
Get-Volume | where DriveLetter -eq D | Format-Volume -FileSystem NTFS -NewFileSystemLabel Data
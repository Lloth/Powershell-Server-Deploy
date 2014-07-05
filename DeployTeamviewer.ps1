mkdir D:\itradix\teamviewer
mv \\drobo-fs\ITR TOOLS\ServerDeployment\TeamViewerMSI_itradix.zip D:\itradix\Teamviewer
$shell = new-object -com shell.application
$zip = $shell.NameSpace("D:\itradix\Teamviewer\TeamViewerMSI_itradix.zip")
foreach($item in $zip.items())
{
$shell.Namespace("D:\itradix\Teamviewer\").copyhere($item)
}
msiexec /i D:\itradix\Teamviewer\Teamviewer_host.msi /quiet
function GetFileAndVerify ($f_filepath, $f_filename, $f_filecachelocation, $f_fileHash, $f_webDownload)
{

    $f_pathOfFile =  $f_filepath + "\" + $f_filename
    $f_pathOfCache =  $f_filecachelocation + "\" + $f_filename
   

        New-Item $f_filepath -type directory -ErrorAction SilentlyContinue
    
        if(Get-FileHash $f_pathOfFile -Algorithm SHA256 -ErrorAction SilentlyContinue | ? {$_.hash -match $f_fileHash})
        {
            write-host "File Already Exists"
            return $true
        } else {
            if(Test-Path $f_filecachelocation)  #Download from Local Share
            {
             
                write-host "Get file from local share"
               
                copy-item $f_pathOfCache -destination $f_pathOfFile 
                 write-host $f_pathOfCache
            }else {
                
                write-host "Download the file from web" 
                wget $f_webDownload -OutFile $f_pathOfFile   
            }
            if(Get-FileHash $f_pathOfFile -Algorithm SHA256 -ErrorAction SilentlyContinue | ? {$_.hash -notmatch $f_fileHash})
            {
                write-host "File does not match hash"
                return $false
            }else {
                write-host "Success! File downloaded matches hash" 
                return $true
            }
           
        }
        return $false
}
$filepath = "C:\tools\openmanage"
$filename = "OM_SMTD_740_A00.iso"
$filecachelocation = ""
$fileHash = "f2ec721d988585faa72191fdaf2df7236a9cf9f3c3956a08eae422eb2e4b3932"
$webDownload  = "ftp://ftp.dell.com/secure//FOLDER02027063M/1/OM_SMTD_740_A00.iso"  

$pathOfFile =  $filepath + "\" + $filename
$pathOfCache =  $filecachelocation + "\" + $filename 



if(GetFileAndVerify $filepath $filename $filecachelocation $fileHash $webDownload)
{$beforeMount = (Get-Volume).DriveLetter

$mountResult = Mount-DiskImage -ImagePath ($pathOfFile)

$setuppath = (compare $beforeMount (Get-Volume).DriveLetter -PassThru) + ":\"
$setuppath
cd  $setuppath
cd ".\SYSMGMT\srvadmin\windows\SystemsManagementx64\"
msiexec.exe /i SysMgmtx64.msi ADDLOCAL="ALL" /qn
Dismount-DiskImage $setuppath
}

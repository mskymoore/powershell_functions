function Get-Uninstallers-By-Publisher(){
    Param(
        [Parameter(Mandatory=$false)][Alias("-v")][switch]$VerboseMode,
        [Parameter(Mandatory=$true)][Alias("pubs")][string[]]$ChosenPublishers
    )

    $UninstallRegKeys=@(
	    "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall",            
    	"SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
    )

    foreach($UninstallRegKey in $UninstallRegKeys) {            
        try {            
             $HKLM   = [microsoft.win32.registrykey]::OpenBaseKey('LocalMachine',[Microsoft.Win32.RegistryView]::Default)            
             $UninstallRef  = $HKLM.OpenSubKey($UninstallRegKey)            
             $Applications = $UninstallRef.GetSubKeyNames()            
        } 
        catch {            
             Write-Verbose "Failed to read $UninstallRegKey"            
             Continue            
        }            
                 
        foreach ($App in $Applications) {            
             $AppRegistryKey  = $UninstallRegKey + "\\" + $App            
             $AppDetails   = $HKLM.OpenSubKey($AppRegistryKey)                       
             $AppPublisher  = $($AppDetails.GetValue("Publisher"))                       
             $AppUninstall  = $($AppDetails.GetValue("UninstallString"))                     
             if(!$AppPublisher){ continue }
             if($VerboseMode){
                 foreach ($Pub in $ChosenPublishers){
                     if($AppPublisher.Contains($Pub)){
                         Write-Output "*************************************"
                         Write-Output "App Name:"
                                       $App
                         Write-Output ""
                         Write-Output "App Publisher:"
                                       $AppPublisher
                         Write-Output ""
                         Write-Output "App Key:"
                                       $AppRegistryKey
                         Write-Output ""
                         Write-Output "Uninstall String:"
                                       $AppUninstall
                         Write-Output "*************************************"
                     }
                 }
             }
             else{
                 foreach ($Pub in $ChosenPublishers){
                     if($AppPublisher.Contains($Pub)){
                         $AppUninstall
                     }
                 }
             }
             
        }            
    }
}

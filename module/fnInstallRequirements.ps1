function fnInstallRequirements{
    [CmdletBinding()]
    $ModulePaths = $env:PSModulePath -split ';'

    $InstallFont = {
        #Adapted from https://gist.github.com/anthonyeden/0088b07de8951403a643a8485af2709b
        $OpenDyslexic = Get-ChildItem "E:\Documents\GitHub\PSGame\Theodora\dat\OpenDyslexic\*.otf"
        $Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
        $TempFolder  = "C:\Windows\Temp\Fonts"
        New-Item $TempFolder -Type Directory -Force | Out-Null
        $OpenDyslexic | ForEach-Object {
            If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
            $Font = "$TempFolder\$($_.Name)"
            Copy-Item $($_.FullName) -Destination $TempFolder
            $Destination.CopyHere($Font,0x10)
            Remove-Item $Font -Force
            }
        }
    }
    $ExcelCheck = {
            $ModuleVerification = @()
            Foreach($Path in $ModulePaths){
               $Result = Test-Path $path\ImportExcel
               $ModuleVerification += $Result
            }
        if($ModuleVerification -contains "True"){}
        else{
            Install-Module ImportExcel -Scope CurrentUser -Force
        }
    }
    $AsciiCheck = {
            $ModuleVerification = @()
            Foreach($Path in $ModulePaths){
               $Result = Test-Path $path\WriteAscii
               $ModuleVerification += $Result
            }
        if($ModuleVerification -contains "True"){}
        else{
            Install-Module WriteAscii -Scope CurrentUser -Force
        }
    }
    $ModuleCheck = {
        &$AsciiCheck
        &$ExcelCheck
    }
    &$ModuleCheck
    &$InstallFont
}
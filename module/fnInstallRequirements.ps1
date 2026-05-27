function fnInstallRequirements{
    [CmdletBinding()]
    $ModulePaths = $env:PSModulePath -split ';'
    $ModuleCheck = {
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
    &$ModuleCheck
}
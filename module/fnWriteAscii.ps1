function fnWriteAscii{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String[]] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("Large","Small")]
        [String] $Font
    )
    foreach($Text in $InputObject){
        $ASCII = fnGetAscii $Text $Font
        Write-Host ($ASCII -join "`n")
    }
}
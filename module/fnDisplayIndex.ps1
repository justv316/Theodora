function fnDisplayIndex{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$Index = 0
    )
        fnDisplayGame $Index
}
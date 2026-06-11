function fnWriteAscii{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [Alias('InputText')]
        [String[]] $InputObject
    )

    #$LetterArray = [String[]]($Letters.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Name)
    #$AcceptedChars = [regex] ( '(?i)[^' + ([regex]::Escape(($LetterArray -join '')) -replace '-', '\-' -replace '\]', '\]') + ' ]' )
    #if($InputObject -match $AcceptedChars){
    #    "Unsupported Character."
    #    Return
    #}
    foreach($Text in $InputObject){
        $ASCII = fnGetAscii ($Text -replace ' ', '_')
        Write-Host ($ASCII -join "`n")
    }
}
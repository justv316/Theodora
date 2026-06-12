function fnWriteAscii{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String[]] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("Large","Small")]
        [String] $Font,
        [ValidateSet("Unspecified","Box")]
        [String] $BuildType = "Unspecified",
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [Alias('Foreground')]
        [String] $ForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [Alias('Background')]
        [String] $BackgroundColor = 'Default'
    )
    if($BuildType -ne "Unspecified"){
        foreach($Text in $InputObject){
            $ASCII = fnGetAscii $Text $Font
            $ConstructedASCII = fnBuildASCII $ASCII $BuildType
        }
        foreach($Line in $ConstructedASCII){
            Write-Host $Line
        }
    }
    if($BuildType -eq "Unspecified"){
        foreach($Text in $InputObject){
            $ASCII = fnGetAscii $Text $Font
            if($ForegroundColor -ne 'Default' -and $BackgroundColor -ne 'Default'){
                if($ForegroundColor -ieq 'rainbow' -or $BackGroundColor -ieq 'rainbow'){
                    $ASCII | ForEach-Object {
                        fnWriteRainbow -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -Line $_
                    }
                }
                else{
                    Write-Host -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor ($ASCII -join "`n")
                }
            }
            elseif($ForegroundColor -ne 'Default'){
                if($ForegroundColor -ieq 'rainbow'){
                    $ASCII | ForEach-Object {
                        fnWriteRainbow -ForegroundColor $ForegroundColor -Line $_
                    }
                }
                else{
                    Write-Host -ForegroundColor $ForegroundColor ($ASCII -join "`n")
                }
            }
            elseif($BackgroundColor -ne 'Default'){
                if($BackgroundColor -ieq 'rainbow'){
                    $ASCII | ForEach-Object {
                        fnWriteRainbow -BackgroundColor $BackgroundColor -Line $_
                    }
                }
                else{
                    Write-Host -BackgroundColor $BackgroundColor ($ASCII -join "`n")
                }
            }
            else{
                Write-Host ($ASCII -join "`n")
            }
        }
    }
}
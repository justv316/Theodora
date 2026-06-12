function fnWriteAscii{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String[]] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("Large","Small")]
        [String] $Font,
        [ValidateSet("Unspecified","SingleBox","DoubleBox","SingleDoubleBox")]
        [String] $BuildType = "Unspecified",
        [ValidateSet("Center","Left","Right")]
        [String] $Justification = "Center",
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $ForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BackgroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextBackgroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BorderForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BorderBackgroundColor = 'Default'
    )
    begin{
        $Colors = @($ForegroundColor, $BackgroundColor, $TextForegroundColor, $TextBackgroundColor, $BorderForegroundColor, $BorderBackgroundColor)
        foreach($Text in $InputObject){
            $ASCII = fnGetAscii $Text $Font
            if($BuildType -ne "Unspecified"){
                $ConstructedASCII = fnBuildASCII $ASCII $BuildType $Justification
            }
        }
    }
    process{
        if($BuildType -ne "Unspecified"){
            foreach($Line in $ConstructedASCII){
                if($ForegroundColor -ne 'Default' -and $BackgroundColor -ne 'Default'){
                    if($ForegroundColor -ieq 'rainbow' -or $BackGroundColor -ieq 'rainbow'){
                        fnWriteRainbow -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -Line $Line
                    }
                    else{
                        Write-Host $Line -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
                    }
                }
                elseif($ForegroundColor -ne 'Default'){
                    if($ForegroundColor -ieq 'rainbow'){
                        fnWriteRainbow -ForegroundColor $ForegroundColor -Line $Line
                    }
                    else{
                        Write-Host $Line -ForegroundColor $ForegroundColor
                    }
                }
                elseif($BackgroundColor -ne 'Default'){
                    if($BackgroundColor -ieq 'rainbow'){
                        fnWriteRainbow -BackgroundColor $BackgroundColor -Line $Line
                    }
                    else{
                        Write-Host $Line BackgroundColor $BackgroundColor
                    }
                }
                else{
                    Write-Host $Line
                }
            }
        }
        if($BuildType -eq "Unspecified"){
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
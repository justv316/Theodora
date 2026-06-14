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
        [ValidateSet("Center","Left","Right","None")]
        [String] $Justification = "Center",
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $ForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BackgroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextBackgroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BorderForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BorderBackgroundColor = 'Default'
    )
    begin{
        foreach($Text in $InputObject){
            $ASCII = fnGetAscii $Text $Font
            if($BuildType -ne "Unspecified"){
                $ConstructedASCII = fnBuildASCII $ASCII $BuildType $Justification
                if($TextForegroundColor -ne 'default' -or $TextBackgroundColor -ne 'default' -or $BorderForegroundColor -ne 'default' -or $BorderBackgroundColor -ne 'default'){
                    $ConstructedASCII = fnBuildASCII $ASCII $BuildType $Justification -Segmented
                }
            }
        }
    }
    process{
        if($BuildType -ne "Unspecified"){
            #All Specifics are Default
            if($TextForegroundColor -eq 'default' -and $TextBackgroundColor -eq 'default' -and $BorderForegroundColor -eq 'default' -and $BorderBackgroundColor -and 'default'){
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
            elseif($TextForegroundColor -ne 'default' -or $TextBackgroundColor -ne 'default' -or $BorderForegroundColor -ne 'default' -or $BorderBackgroundColor -ne 'default'){
                $LineCount = $ConstructedASCII.Length
                $MaxLines = $ASCII.Length
                $LineCounter = 1
                $ASCIICounter = 1
                $Counter = 1
                #Get the number of Borderlines - Will always be at least the first and last lines
                $BorderLines = @(
                    1, $ConstructedASCII.Length
                )
                #If there are more BorderLines, we add them to the array
                if(($Boxes[$($BuildType)])["OuterBorderLines"] -gt 1){
                    $BorderLines += ($Boxes[$($BuildType)])["OuterBorderLines"]
                    $BorderLines += $ConstructedASCII.Length - 1
                }
                if($BorderForegroundColor -ne 'Default' -and $BorderBackgroundColor -ne 'Default'){}  
                if($BorderForegroundColor -ne 'Default' -and $BorderBackgroundColor -ne 'Default'){
                    #Both BorderColors have been specified. We need to paint just the border rows, and then break down the input text to paint the border characters separately from the text characters
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
            }
        }
        if($BuildType -eq "Unspecified"){
            #Unspecified Build does not have a border. Therefore, default colors are considered "TextColors"
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
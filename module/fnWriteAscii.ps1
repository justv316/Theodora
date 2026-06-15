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
        [String] $BorderBackgroundColor = 'Default',
        [int]$EnforcedMaxLength = 160,
        [int]$MinimumPaddingLength = 4
    )
    begin{
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Letters)){
            fnXMLLetter
        }
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters)){
            fnXMLCharacter
        } 
        $Script:Boxes = @{
            "SingleBox" = @{
            "BorderLines" = 2
            "OuterBorderLines" = 1
            "OuterBorder" = $Characters.SingleVertical
            "OuterHorizontalBorder" = $Characters.SingleHorizontal
            "OuterTopBorderLC" = $Characters.SingleTopLeftCorner
            "OuterTopBorderRC" = $Characters.SingleTopRightCorner
            "OuterBottomBorderLC" = $Characters.SingleBottomLeftCorner
            "OuterBottomBorderRC" = $Characters.SingleBottomRightCorner
            "LeftBorder" = $Characters.SingleVertical
            "RightBorder" = $Characters.SingleVertical
            }
            "DoubleBox" = @{
            "BorderLines" = 2
            "OuterBorderLines" = 1
            "OuterBorder" = $Characters.DoubleVertical
            "OuterHorizontalBorder" = $Characters.DoubleHorizontal
            "OuterTopBorderLC" = $Characters.DoubleTopLeftCorner
            "OuterTopBorderRC" = $Characters.DoubleTopRightCorner
            "OuterBottomBorderLC" = $Characters.DoubleBottomLeftCorner
            "OuterBottomBorderRC" = $Characters.DoubleBottomRightCorner
            "LeftBorder" = $Characters.DoubleVertical
            "RightBorder" = $Characters.DoubleVertical
            }
            "SingleDoubleBox" = @{
            "BorderLines" = 4
            "OuterBorderLines" = 2
            "OuterBorder" = $Characters.DoubleVertical
            "OuterHorizontalBorder" = $Characters.DoubleHorizontal
            "OuterTopBorderLC" = $Characters.DoubleTopLeftCorner
            "OuterTopBorderRC" = $Characters.DoubleTopRightCorner
            "OuterBottomBorderLC" = $Characters.DoubleBottomLeftCorner
            "OuterBottomBorderRC" = $Characters.DoubleBottomRightCorner
            "InnerBorder" = $Characters.SingleVertical
            "InnerHorizontalBorder" = $Characters.SingleHorizontal
            "InnerTopBorderLC" = $Characters.SingleTopLeftCorner
            "InnerTopBorderRC" = $Characters.SingleTopRightCorner
            "InnerBottomBorderLC" = $Characters.SingleBottomLeftCorner
            "InnerBottomBorderRC" = $Characters.SingleBottomRightCorner
            "LeftBorder" = $Characters.DoubleVertical + $Characters.SingleVertical
            "RightBorder" = $Characters.SingleVertical + $Characters.DoubleVertical
            }
        }
        foreach($Text in $InputObject){
            $ASCII = fnGetAscii $Text $Font $Buildtype $EnforcedMaxLength $MinimumPaddingLength
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
            if($TextForegroundColor -eq 'default' -and $TextBackgroundColor -eq 'default' -and $BorderForegroundColor -eq 'default' -and $BorderBackgroundColor -eq 'default'){
                #All Specifics are Default
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
            # At least 1 specific color is specified
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
                if($BorderForegroundColor -ne 'Default' -and $BorderBackgroundColor -ne 'Default' -and $TextForegroundColor -ne 'Default' -and $TextBackgroundColor -ne 'Default'){
                    #All 4 Specific Colors have been specified
                     while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                            }
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    if($TextForegroundColor -eq 'rainbow' -or $TextBackGroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1]-ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -NoNewLine
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                        Write-Host ' '
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                                    }
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($BorderForegroundColor -ne 'Default' -and $BorderBackgroundColor -ne 'Default' -and $TextForegroundColor -ne 'Default'){
                    #TextBackGround is Default, all 3 Other Specific colors have been set
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                            }
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    if($TextForegroundColor -eq 'rainbow'){
                                          fnWriteRainbow -ForegroundColor $TextForegroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine -ForegroundColor $TextForegroundColor
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                        Write-Host ' '
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                                    }
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($BorderForegroundColor -ne 'Default' -and $BorderBackgroundColor -ne 'Default' -and $TextBackgroundColor -ne 'Default'){
                    #TextForeGround is Default, all 3 Other Specific colors have been set
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                            }
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
                                    if($TextBackgroundColor -eq 'rainbow'){
                                          fnWriteRainbow -BackgroundColor $TextBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine -BackgroundColor $TextBackgroundColor
                                    }
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
                elseif($BorderForegroundColor -ne 'Default' -and $BorderBackgroundColor -ne 'Default'){
                    #Both BorderColors have been specified and text colors are default.
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                            }
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                        Write-Host ' '
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                                    }
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($TextForegroundColor -ne 'Default' -and $TextBackgroundColor -ne 'Default'){
                    #Both TextColors have been specified and Border colors are default.
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            Write-Host $ConstructedASCII[$LineCounter-1]
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    if($TextForegroundColor -eq 'rainbow' -or $TextBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine -ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    Write-Host $ConstructedASCII[$LineCounter-1]
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($TextForegroundColor -ne 'Default'){
                    #Only TextForeground is set
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            Write-Host $ConstructedASCII[$LineCounter-1]
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    Write-Host $ConstructedASCII[$LineCounter-1]  -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    if($TextForegroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $TextForegroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine -ForegroundColor $TextForegroundColor
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    Write-Host $ConstructedASCII[$LineCounter-1]
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($TextBackgroundColor -ne 'Default'){
                    #Only TextBackground is set
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            Write-Host $ConstructedASCII[$LineCounter-1]
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    Write-Host $ConstructedASCII[$LineCounter-1]  -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    if($TextBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -BackgroundColor $TextBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine -BackgroundColor $TextBackgroundColor
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    Write-Host $ConstructedASCII[$LineCounter-1]
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($BorderForegroundColor -ne 'Default'){
                    #Only BorderForeground is set
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            if($BorderForegroundColor -eq 'rainbow'){
                                fnWriteRainbow -ForegroundColor $BorderForegroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor
                            }
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    if($BorderForegroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -NoNewLine
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    if($BorderForegroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                        Write-Host ' '
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor
                                    }
                                    $Counter = 1
                                    $LineCounter++
                                    $ASCIICounter++
                                }
                            }
                        }
                    }
                }
                elseif($BorderBackgroundColor -ne 'Default'){
                    #Only BorderBackground is set
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            if($BorderBackgroundColor -eq 'rainbow'){
                                fnWriteRainbow -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -BackgroundColor $BorderBackgroundColor
                            }
                            $LineCounter++
                        }
                        else{
                            if($ASCIICounter -le $MaxLines){
                                if($Counter -eq 1){
                                    if($BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -BackgroundColor $BorderBackgroundColor -NoNewLine
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    Write-Host $ConstructedASCII[$LineCounter-1] -NoNewLine
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    if($BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                        Write-Host ' '
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -BackgroundColor $BorderBackgroundColor
                                    }
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
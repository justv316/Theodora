
<#
.ATTRIBUTION 
    Material: Get-LetterXML, Reference material for the factory
    Author: Joakim Borger Svendsen WriteAscii Module
    Without you this would have sucked so much more to write
#>

function fnElementFactory{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [ValidateSet("String")]
        [String]$BuildType,
        [Parameter(Mandatory=$False)]
        [String]$InputString = "",
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextForegroundColor = 'White',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextBackgroundColor = 'Black',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BorderForegroundColor = 'White',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BorderBackgroundColor = 'Black',
        [Switch] $Manual,
        [Switch] $Box,
        [Switch] $Border,
        [String] $ManualFormatting = "",
        [ValidateSet("Center","Left","Right")]
        [String] $Justification = "Center",
        [ValidateSet("DoubleSingle", "Double")]
        [String] $BorderType = "DoubleSingle",
        [Int]$EnforcedMaxLength = 80,
        [Int]$MinimumPaddingLength = 4,
        [Int]$LineCount = 1,
        [String] $Padding = " "
    )
<#
    .SYNOPSIS
    This script will produce elements that will be printed to the screen using a set of basic characters.
    .PARAMETERS
    (String) InputString - The string to be printed
    (String) BuildType - What structure should be produced (String)
    (Bool) Box - Draws a Box (Requires Border)
    (Bool) Border - Draws a Border
    (String) BorderType - What border should be produced (Default: DoubleSingle, Double)
    (String) Justification - Justifies the text (Default: Center, Left, Right)
    (Int) EnforcedMaxLength - The max length of a string (Default: 80)
    (Int) MinimumPaddingLength - The minimum amount of padding to be added to each side of a string (Default: 4)
    (Int) LineCount - How many lines should the text be printed to [Needs to be designed, apparently]
    (String) Padding - The character used for padding (Default: Space)
    (Bool) Manual - Enables manual Formatting, requires ManualFormatting
    (String) ManualFormatting
        Order of Parameters does not matter
        "Example: -ind 1 fg red bg cyan -line 1 ind 5 fg green bg white"
        Ind [0-79]: Which characters formatting should be changed.
        Line - Which Line number should be selected
        FG - ForegroundColor
        BG - BackgroundColor
#>

    $fnWriteManual = {
        param(
            [String]$StringToArr
        )
        $LetterArr = @()
        $Counter = 0
        [Char[]]$StringToArr | Foreach-Object {
            $LetterArr += $_
        }
        $LetterArr | Foreach-Object {
            if($ModifiedIndex -Contains $Counter){
                $Expression = "`$Write_"+"$Counter"
                Invoke-Expression $Expression | Invoke-Expression
            }
            else{
                Write-Host $_ -ForegroundColor 'White' -BackgroundColor 'Black' -NoNewline
            }
            $Counter++
        }
        if($Counter -eq $LetterArr.Count){
            Write-Host "`r"
        }
    }
    
    #Build the Character Hash if it hasn't been done yet.
    if($CharXML -eq "" -or $null -eq $CharXML){
        $CharacterFile = 'E:\Documents\GitHub\PSGame\Theodora\module\characters.xml'
        $CharXml = [xml] (Get-Content $CharacterFile)
        $Characters = @{}
        $CharXml.Chars.Char | ForEach-Object {
            $Characters[$($_.Name)] = $_.Data
        }
    }
    if($Border){
        if($BorderType -eq "Double"){
            $LeftBorder = $Characters.DoubleVertical
            $RightBorder = $Characters.DoubleVertical
            $TopBorderLC = $Characters.DoubleTopLeftCorner
            $TopBorderRC = $Characters.DoubleTopRightCorner
            $BottomBorderLC = $Characters.DoubleBottomLeftCorner
            $BottomBorderRC = $Characters.DoubleBottomRightCorner
            $HorizontalBorder = $Characters.DoubleHorizontal
        }
        elseif($BorderType -eq "DoubleSingle"){
            $OuterBorder = $Characters.DoubleVertical
            $InnerBorder = $Characters.SingleVertical
            $LeftBorder = $OuterBorder + $InnerBorder
            $RightBorder = $InnerBorder + $OuterBorder
            $TopBorderLC = $Characters.DoubleTopLeftCorner
            $TopBorderRC = $Characters.DoubleTopRightCorner
            $BottomBorderLC = $Characters.DoubleBottomLeftCorner
            $BottomBorderRC = $Characters.DoubleBottomRightCorner
            $HorizontalBorder = $Characters.DoubleHorizontal
            $InnerTopBorderLC = $Characters.SingleTopLeftCorner
            $InnerTopBorderRC = $Characters.SingleTopRightCorner
            $InnerBottomBorderLC = $Characters.SingleBottomLeftCorner
            $InnerBottomBorderRC = $Characters.SingleBottomRightCorner
            $InnerHorizontalBorder = $Characters.SingleHorizontal
        }
    }
    elseif($Border -eq $False){
        $LeftBorder = ""
        $RightBorder = ""
    }
    if($Box){
        if($BorderType -eq "DoubleSingle"){
            $TopBorder = $TopBorderLC + (($HorizontalBorder)*($EnforcedMaxLength-2)) + $TopBorderRC
            $BottomBorder = $BottomBorderLC + (($HorizontalBorder)*($EnforcedMaxLength-2)) + $BottomBorderRC
            $InnerTopBorder = $OuterBorder + $InnerTopBorderLC + (($InnerHorizontalBorder)*($EnforcedMaxLength-4)) + $InnerTopBorderRC + $OuterBorder
            $InnerBottomBorder = $OuterBorder + $InnerBottomBorderLC + (($InnerHorizontalBorder)*($EnforcedMaxLength-4)) + $InnerBottomBorderRC + $OuterBorder
        }
        elseif($BorderType -eq "Double"){
            $TopBorder = $TopBorderLC + (($HorizontalBorder)*($EnforcedMaxLength-2)) + $TopBorderRC
            $BottomBorder = $BottomBorderLC + (($HorizontalBorder)*($EnforcedMaxLength-2)) + $BottomBorderRC
        }
    }
    if($BuildType -eq "String"){
        $InputLength = $InputString.Length
        $StringHash = [Ordered] @{}
        $LineHash = @{}
        $ReversedLineHash = [Ordered] @{}
        $StringArr=@()
        $PerceivedStringMax = $EnforcedMaxLength - ($MinimumPaddingLength*2) - ($LeftBorder.Length + $RightBorder.Length)
        $LinesNeeded = [Math]::Ceiling($InputLength / $PerceivedStringMax)
        $Counter = 1
        $NextStringIndex = 0
        while($Counter -le $LinesNeeded){
            try{
                $LineHash.$Counter = $InputString.Substring($NextStringIndex,($PerceivedStringMax))
            }
            catch{
                $LineHash.$Counter = $InputString.Substring($NextStringIndex)
            }
            finally{
                $NextStringIndex = $NextStringIndex+$PerceivedStringMax
                $Counter++
            }
        }
        Foreach ($Key in $LineHash.Keys){
            $ReversedLineHash.Insert(0, $Key, $LineHash[$Key])
        }
        Foreach ($Key in $ReversedLineHash.Keys){
            $SubStringLength = $ReversedLineHash.$Key.Length
            if($Justification -eq "Center"){
                $LeftPaddingRequired = (($EnforcedMaxLength / 2) - ($SubStringLength / 2) - $LeftBorder.Length)
                $RightPaddingRequired = (($EnforcedMaxLength / 2) - ($SubStringLength / 2) - $RightBorder.Length)
                $RightPaddingRequired = [Math]::floor($RightPaddingRequired)
                $LeftPaddingRequired = [Math]::ceiling($LeftPaddingRequired)
            }
            elseif($Justification -eq "Left"){
                $LeftPaddingRequired = $MinimumPaddingLength
                $RightPaddingRequired = (($EnforcedMaxLength - $SubStringLength) - ($RightBorder.Length + $LeftBorder.Length)) - $LeftPaddingRequired
            }
            elseif($Justification -eq "Right"){
                $RightPaddingRequired = $MinimumPaddingLength
                $LeftPaddingRequired = (($EnforcedMaxLength - $SubStringLength) - ($RightBorder.Length + $LeftBorder.Length)) - $RightPaddingRequired
            }
            $LeftPadding = ($Padding)*($LeftPaddingRequired)
            $LeftPadding = $LeftBorder + $LeftPadding
            $RightPadding = ($Padding)*($RightPaddingRequired)
            $RightPadding = $RightPadding + $RightBorder
            if($Manual){
                $PaddedString = "$LeftPadding"+$ReversedLineHash.$Key+"$RightPadding"
                $StringHash.Add("$Key","$PaddedString")
            }
            else{
                $StringArr += $LeftPadding
                $StringArr += $ReversedLineHash.$Key
                $StringArr += $RightPadding
            }
        }
        if($Manual){
            $FormatArr = @()
            [System.Collections.ArrayList]$FormatArr = $ManualFormatting.Split("-")
            if($FormatArr[0] -eq ""){
                $FormatArr.RemoveAt(0)
            }
            #Turn the Format String into a modified write-host command
            $ModifiedIndex = @()
            $ModifiedLine = @()
            $FormatArr | ForEach-Object{
                $String = $_
                $IndexRegex = '\bind\b\s(\d+)'
                $LineRegex = '\bline\b\s(\d+)'
                $FGRegex = '\bfg\b\s([A-Za-z]+)'
                $BGRegex = '\bbg\b\s([A-Za-z]+)'
                $Matches = $null
                if($String -match $LineRegex){
                    $String -match $LineRegex | Out-Null
                    $ManualLine = $Matches[1] -as [Int]
                    $ModifiedLine += $ManualLine
                }
                $Matches = $null
                if($String -Match $IndexRegex){
                    $String -match $IndexRegex | Out-Null
                    $Index = $Matches[1] -as [Int]
                    $ModifiedIndex += $Index
                }
                $Matches = $null
                if($String -match $FGRegex){
                    $String -match $FGRegex | Out-Null
                    $FG = $Matches[1]
                }
                $Matches = $null
                if($String -match $BGRegex){
                    $String -match $BGRegex | Out-Null
                    $BG = $Matches[1]
                }
                Set-Variable -Name "write_$($Index)" -Value "Write-Host `$LetterArr[$($Index)] -ForegroundColor $($FG) -BackgroundColor $($BG) -NoNewLine"
            }
            if($Box){
                if($BorderType -eq "DoubleSingle"){
                    $Counter = 1
                    $BorderLines = 4
                    $FinalLinesNeeded = $LinesNeeded + $BorderLines
                    while($Counter -le $FinalLinesNeeded){
                        if($ModifiedLine.Count -gt 0){
                            if($ModifiedLine -Contains $Counter){
                                if($Counter -eq 1){
                                    &$fnWriteManual -StringToArr $TopBorder
                                }
                                elseif($Counter -eq 2){
                                    &$fnWriteManual -StringToArr $InnerTopBorder
                                }
                                elseif($Counter -gt 2 -and $Counter -ne $FinalLinesNeeded){
                                    &$fnWriteManual -StringToArr $StringHash["$Counter"-"$BorderLines"]
                                }
                                elseif($Counter -eq $FinalLinesNeeded-1){
                                    &$fnWriteManual -StringToArr $InnerBottomBorder
                                }
                                elseif($Counter -eq $FinalLinesNeeded){
                                    &$fnWriteManual -StringToArr $BottomBorder
                                }
                                $Counter++
                            }
                            else{
                                if($Counter -eq 1){
                                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                                }
                                elseif($Counter -eq 2){
                                    Write-Host $InnerTopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                                }
                                elseif($Counter -gt 2 -and $Counter -ne $FinalLinesNeeded){
                                    Write-Host $StringHash["$Counter"-"$BorderLines"] -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor
                                }
                                elseif($Counter -eq $FinalLinesNeeded-1){
                                    Write-Host $InnerBottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                                }
                                elseif($Counter -eq $FinalLinesNeeded){
                                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                                }
                                $Counter++
                            }
                        }
                        else{
                            if($Counter -eq 1){
                                &$fnWriteManual -StringToArr $TopBorder
                            }
                            elseif($Counter -eq 2){
                                &$fnWriteManual -StringToArr $InnerTopBorder
                            }
                            elseif($Counter -gt 2 -and $Counter -ne $FinalLinesNeeded){
                                &$fnWriteManual -StringToArr $StringHash["$Counter"-"$BorderLines"]
                            }
                            elseif($Counter -eq $FinalLinesNeeded-1){
                                &$fnWriteManual -StringToArr $InnerBottomBorder
                            }
                            elseif($Counter -eq $FinalLinesNeeded){
                                &$fnWriteManual -StringToArr $BottomBorder
                            }
                            $Counter++
                        }
                    }
                }
                elseif($BorderType -eq "Double"){
                    $Counter = 1
                    $BorderLines = 2
                    $FinalLinesNeeded = $LinesNeeded + $BorderLines
                    while($Counter -le $FinalLinesNeeded){
                        if($ModifiedLine.Count -gt 0){
                            if($ModifiedLine -Contains $Counter){
                                if($Counter -eq 1){
                                    &$fnWriteManual -StringToArr $TopBorder
                                }
                                elseif($Counter -ne 1 -and $Counter -ne $FinalLinesNeeded){
                                    &$fnWriteManual -StringToArr $StringHash["$Counter"-"$BorderLines"]
                                }
                                elseif($Counter -eq $FinalLinesNeeded){
                                    &$fnWriteManual -StringToArr $BottomBorder
                                }
                                $Counter++
                            }
                            else{
                                if($Counter -eq 1){
                                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                                }
                                elseif($Counter -ne 1 -and $Counter -ne $FinalLinesNeeded){
                                    Write-Host $StringHash["$Counter"-"$BorderLines"] -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor
                                }
                                elseif($Counter -eq $FinalLinesNeeded){
                                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                                }
                                $Counter++
                            }
                        }
                        else{
                            if($Counter -eq 1){
                                &$fnWriteManual -StringToArr $TopBorder
                            }
                            elseif($Counter -ne 1 -and $Counter -ne $FinalLinesNeeded){
                                &$fnWriteManual -StringToArr $StringHash["$Counter"-"$BorderLines"]
                            }
                            elseif($Counter -eq $FinalLinesNeeded){
                                &$fnWriteManual -StringToArr $BottomBorder
                            }
                            $Counter++
                        }
                    }
                }
            }
            else{
                Foreach($String in $StringHash.Keys){
                    &$fnWriteManual -StringToArr $StringHash.$String
                }
            }
        }
        else{
            if($Box){
                if($BorderType -eq "DoubleSingle"){
                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $InnerTopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    $Counter = 1
                    $Counter2 = 0
                    while($Counter -le 3){
                        if($Counter2 -le $StringArr.Count - 1){
                            if($Counter -eq 1){
                                $Counter++
                                Write-Host $StringArr[$Counter2] -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor -NoNewline
                            }
                            elseif($Counter -eq 2){
                                $Counter++
                                Write-Host $StringArr[$Counter2] -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
                            }
                            elseif($Counter -eq 3){
                                $Counter = 1
                                Write-Host $StringArr[$Counter2] -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                            }
                            $Counter2++
                        }
                        elseif($Counter2 -eq $StringArr.Count){
                            break
                        }
                    }
                    Write-Host $InnerBottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                }
                elseif($BorderType -eq "Double"){
                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    $Counter = 1
                    $Counter2 = 0
                    while($Counter -le 3){
                        if($Counter2 -le $StringArr.Count - 1){
                            if($Counter -eq 1){
                                $Counter++
                                Write-Host $StringArr[$Counter2] -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor -NoNewline
                            }
                            elseif($Counter -eq 2){
                                $Counter++
                                Write-Host $StringArr[$Counter2] -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
                            }
                            elseif($Counter -eq 3){
                                $Counter = 1
                                Write-Host $StringArr[$Counter2] -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                            }
                            $Counter2++
                        }
                        elseif($Counter2 -eq $StringArr.Count){
                            break
                        }
                    }
                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                }
            }
            else{
                $Counter = 1
                $Counter2 = 0
                while($Counter -le 3){
                    if($Counter2 -le $StringArr.Count - 1){
                        if($Counter -eq 1){
                            $Counter++
                            Write-Host $StringArr[$Counter2] -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor -NoNewline
                        }
                        elseif($Counter -eq 2){
                            $Counter++
                            Write-Host $StringArr[$Counter2] -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
                        }
                        elseif($Counter -eq 3){
                            $Counter = 1
                            Write-Host $StringArr[$Counter2] -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                        }
                        $Counter2++
                    }
                    elseif($Counter2 -eq $StringArr.Count){
                        break
                    }
                }
            }
        }
    }
}
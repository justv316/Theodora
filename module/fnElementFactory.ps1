
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
        [String]$InputString,
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
        [String] $ManualFormatting,
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
    This script will produce elements that will be printed to the screen using a set of basic characters.
    Parameter InputString - The String to be printed surrounded by a border
    ManualFormatting - Index number[0-79]: Which characters formatting should be changed."Example: -ind 1 fg red bg cyan -ind 5 fg green bg white"
    #>

    $fnManualFormat = {
        param(
            [String]$StringToArr
        )
        $LetterArr = @()
        [Char[]]$StringToArr | Foreach-Object {
            $LetterArr += $_
        }
        [System.Collections.ArrayList]$FormatArr = $ManualFormatting.Split("-")
        if($FormatArr[0] -eq ""){
            $FormatArr.RemoveAt(0)
        }
        #Turn the Format String into a modified write-host command
        $ModifiedIndex = @()
        $FormatArr | ForEach-Object{
            $String = $_
            $IndexRegex = '(\d+)'
            $Matches = $null
            $String -match $IndexRegex | Out-Null
            $Index = $Matches[0] -as [Int]
            $FGRegex = '\bfg\b\s([A-Za-z]+)'
            $Matches = $null
            $String -match $FGRegex | Out-Null
            $FG = $Matches[1]
            $BGRegex = '\bbg\b\s([A-Za-z]+)'
            $Matches = $null
            $String -match $BGRegex | Out-Null
            $BG = $Matches[1]
            Set-Variable -Name "write_$($Index)" -Value "Write-Host `$LetterArr[$($Index)] -ForegroundColor $($FG) -BackgroundColor $($BG) -NoNewLine"
            $ModifiedIndex += $Index
        }
        $Counter = 0
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
            Write-Host "`r`n"
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
            $InnerBorder = $Characters.SignalVertical
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
        else{
            $TopBorder = $TopBorderLC + (($HorizontalBorder)*($EnforcedMaxLength-2)) + $TopBorderRC
            $BottomBorder = $BottomBorderLC + (($HorizontalBorder)*($EnforcedMaxLength-2)) + $BottomBorderRC
        }
    }
    if($BuildType -eq "String"){
        $InputLength = $InputString.Length        
        $LineHash = @{}
        $PerceivedStringMax = $EnforcedMaxLength - ($MinimumPaddingLength*2) - ($LeftBorder.Length + $RightBorder.Length)
        if($InputLength -gt $PerceivedStringMax){
            $LinesNeeded = [Math]::Ceiling($InputLength / $PerceivedStringMax)
            if($LinesNeeded -gt 1){
                $Counter = 1
                $NextStringIndex = 0
                while($Counter -le $LinesNeeded){
                    $LineHash.$Counter = $InputString.Substring($NextStringIndex,($PerceivedStringMax))
                    $NextStringIndex = $NextStringIndex+1+$PerceivedStringMax
                    $Counter++
                }
            }
        }

        if($Justification -eq "Center"){
            $LeftPaddingRequired = (($EnforcedMaxLength / 2) - ($InputLength / 2) - $LeftBorder.Length)
            $RightPaddingRequired = (($EnforcedMaxLength / 2) - ($InputLength / 2) - $RightBorder.Length)
            $RightPaddingRequired = [Math]::floor($RightPaddingRequired)
            $LeftPaddingRequired = [Math]::ceiling($LeftPaddingRequired)
        }
        elseif($Justification -eq "Left"){
            $LeftPaddingRequired = $MinimumPaddingLength
            $RightPaddingRequired = (($EnforcedMaxLength - $InputLength) - ($RightBorder.Length + $LeftBorder.Length)) - $LeftPaddingRequired
        }
        elseif($Justification -eq "Right"){
            $RightPaddingRequired = $MinimumPaddingLength
            $LeftPaddingRequired = (($EnforcedMaxLength - $InputLength) - ($RightBorder.Length + $LeftBorder.Length)) - $RightPaddingRequired
        }
        $LeftPadding = ($Padding)*($LeftPaddingRequired)
        $LeftPadding = $LeftBorder + $LeftPadding
        $RightPadding = ($Padding)*($RightPaddingRequired)
        $RightPadding = $RightPadding + $RightBorder
        if($Manual){
            if($Box){
                if($BorderType -eq "DoubleSingle"){
                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $InnerTopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    &$fnManualFormat -StringToArr "$LeftPadding$InputString$RightPadding"
                    Write-Host $InnerBottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                }
                else{
                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    &$fnManualFormat -StringToArr "$LeftPadding$InputString$RightPadding"
                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                }
            }
            else{
                &$fnManualFormat -StringToArr "$LeftPadding$InputString$RightPadding"
            }
        }
        else{
            if($Box){
                if($BorderType -eq "DoubleSingle"){
                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $InnerTopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $LeftPadding -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor -NoNewline
                    Write-Host $InputString -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
                    Write-Host $RightPadding -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $InnerBottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                }
                else{
                    Write-Host $TopBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $LeftPadding -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor -NoNewline
                    Write-Host $InputString -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
                    Write-Host $RightPadding -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                    Write-Host $BottomBorder -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
                }
            }
            else{
                Write-Host $LeftPadding -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor -NoNewline
                Write-Host $InputString -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
                Write-Host $RightPadding -BackgroundColor $BorderBackgroundColor -ForegroundColor $BorderForegroundColor
            }
        }
    }
}
function fnElementFactory{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String]$BuildType,
        [Parameter(Mandatory=$False,Position=1)]
        [String]$InputString,
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $LeftForegroundColor = 'White',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $LeftBackgroundColor = 'Black',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $RightForegroundColor = 'White',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $RightBackgroundColor = 'Black',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextForegroundColor = 'White',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $TextBackgroundColor = 'Black',
        [Switch] $Manual,
        [String] $ManualFormatting
    )
<#
    This script will produce elements that will be printed to the screen using a set of basic characters.
    Parameter InputString - The String to be printed surrounded by a border
    ManualFormatting - Index number[0-79]: Which characters formatting should be changed."Example: -ind 1 fg red bg cyan -ind 5 fg green bg white"
    #>
    $Basics = @{
        Padding = " "
        OuterBorder = "║"
        InnerBorder = "│"
    }
    $EnforcedStringLength = 80

    if($BuildType -eq "StringInnerBorder"){
        $InputLength = $InputString.Length
        $LeftBorder = $Basics.OuterBorder + $Basics.InnerBorder
        $RightBorder = $Basics.InnerBorder + $Basics.OuterBorder
        $LeftPaddingRequired = (($EnforcedStringLength / 2) - ($InputLength / 2) - $LeftBorder.Length)
        $LeftPaddingRequired = [Math]::ceiling($LeftPaddingRequired)
        $RightPaddingRequired = (($EnforcedStringLength / 2) - ($InputLength / 2) - $LeftBorder.Length)
        $RightPaddingRequired = [Math]::floor($RightPaddingRequired)
        $LeftPadding = $Basics.Padding*($LeftPaddingRequired)
        $LeftPadding = $LeftBorder + $LeftPadding
        $RightPadding = $Basics.Padding*($RightPaddingRequired)
        $RightPadding = $RightPadding + $RightBorder
        #Build the String with border and padding
        if($Manual){
            $LetterArr = @()
            $StringToArr = $LeftPadding + $InputString + $RightPadding
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
        #Print Each Character in the LetterArr    
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
    else{
        Write-Host $LeftPadding -BackgroundColor $LeftBackgroundColor -ForegroundColor $LeftForegroundColor -NoNewline
        Write-Host $InputString -BackgroundColor $TextBackgroundColor -ForegroundColor $TextForegroundColor -NoNewline
        Write-Host $RightPadding -BackgroundColor $RightBackgroundColor 
    }

}
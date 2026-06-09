Function fnWriteAscii {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [Alias('InputText')]
        [String[]] $InputObject,
        [Alias('Compression')]
        [Switch] $Compress,
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $ForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray","DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BackgroundColor = 'Default',
        [ValidateSet("Large","Small")]
        [String] $Size

    )
    <#
        .DESCRIPTION
        Lowercase letters are prefixed with '-'
        .PARAMETER InputObject
        .PARAMETER Compress
    #>
    begin{
        Function fnGetAscii{
            param(
                [String] $InputObject,
                [ValidateSet("Large","Small")]
                [String] $Size
            )
            $Text = $InputObject -replace ' ','_'
            $LetterArray = [Char[]] $Text
            $MaxLines = 0
            if(-not $Compress -and $Size -eq "Large"){
                $MaxLines = 8
            }
            elseif(-not $Compress -and $Size -eq "Small"){
                $MaxLines = 6
            }
            

            if($Size -eq "Small"){
                $LetterWidthArray = @()
                $LetterLinesArray = @()
                $LetterArray | ForEach-Object{
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ls$($_)"
                        if($Letters.$Letter.Case -eq "Lower" -and $Letters.$Letter.Size -eq "Small"){
                            $LetterWidthArray += $Letters.$Letter.Width
                            $LetterLinesArray += $Letters.$Letter.Lines
                            if($Letters.$Letter.Lines -gt $MaxLines){
                                $MaxLines = $Letters.$Letter.Lines
                            }
                        }
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "us$($_)"
                        if($Letters.$Letter.Case -eq "Upper" -and $Letters.$Letter.Size -eq "Small"){
                            $LetterWidthArray += $Letters.$Letter.Width
                            $LetterLinesArray += $Letters.$Letter.Lines
                            if($Letters.$Letter.Lines -gt $MaxLines){
                                $MaxLines = $Letters.$Letter.Lines
                            }
                        }
                    }
                    elseif($_ -eq "_"){
                        $Letter = "$($_)"
                        $LetterWidthArray += $Letters.$Letter.Width
                        $LetterLinesArray += $Letters.$Letter.Lines
                        if($Letters.$Letter.Lines -gt $MaxLines){
                            $MaxLines = $Letters.$Letter.Lines
                        }
                    }
                }
                $Lines = @{
                    '1' = ''
                    '2' = ''
                    '3' = ''
                    '4' = ''
                    '5' = ''
                    '6' = ''
                }
                $LetterPos = 0
                $LetterArray | ForEach-Object {
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ls$($_)"
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "us$($_)"
                    }
                    elseif($_ -eq "_"){
                        $Letter = "$($_)"
                    }
                    $Letter = [String]$Letter
                    if($LetterLinesArray[$LetterPos] -eq 6){
                        foreach($Num in 1..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-1]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    elseif($LetterLinesArray[$LetterPos] -eq 5){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        foreach($Num in 2..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-2]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    elseif($LetterLinesArray[$LetterPos] -eq 4){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        foreach($Num in 3..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-3]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    elseif($LetterLinesArray[$LetterPos] -eq 3){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        $Lines.'3' += $Padding
                        foreach($Num in 4..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-4]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                $LetterPos++
                }
            } # End If(Size -eq Small)
            if($Size -eq "Large"){
                $LetterWidthArray = @()
                $LetterLinesArray = @()
                $LetterArray | ForEach-Object{
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ll$($_)"
                        if($Letters.$Letter.Case -eq "Lower" -and $Letters.$Letter.Size -eq "Large"){
                            $LetterWidthArray += $Letters.$Letter.Width
                            $LetterLinesArray += $Letters.$Letter.Lines
                            if($Letters.([String] $_).Lines -gt $MaxLines){
                                $MaxLines = $Letters.([String]$_).Lines
                            }
                        }
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "ul$($_)"
                        if($Letters.$Letter.Case -eq "Upper" -and $Letters.$Letter.Size -eq "Large"){
                            $LetterWidthArray += $Letters.$Letter.Width
                            $LetterLinesArray += $Letters.$Letter.Lines
                            if($Letters.([String] $_).Lines -gt $MaxLines){
                                $MaxLines = $Letters.([String]$_).Lines
                            }
                        }
                    }
                    elseif($_ -eq "_"){
                        $Letter = "$($_)"
                        $LetterWidthArray += $Letters.$Letter.Width
                        $LetterLinesArray += $Letters.$Letter.Lines
                        if($Letters.([String] $_).Lines -gt $MaxLines){
                            $MaxLines = $Letters.([String]$_).Lines
                        }
                    }
                }
                $Lines = @{
                    '1' = ''
                    '2' = ''
                    '3' = ''
                    '4' = ''
                    '5' = ''
                    '6' = ''
                    '7' = ''
                    '8' = ''
                }
                $MaxWidth = ($LetterWidthArray | Measure-Object -Maximum).Maximum
                $WidestLetter = $LetterArray | Foreach-Object {
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ll$($_)"
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "ul$($_)"
                    }
                    elseif($_ -eq "_"){
                        $Letter = "$($_)"
                    }
                    if($Letters.$Letter.Width -eq $Maxwidth){
                        $Letters.$Letter
                    }
                }
                $LetterPos = 0
                $LetterArray | ForEach-Object {
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ll$($_)"
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "ul$($_)"
                    }
                    elseif($_ -eq "_"){
                        $Letter = "$($_)"
                    }
                    $Letter = [String]$Letter
                    if($LetterLinesArray[$LetterPos] -eq 8){
                        foreach($Num in 1..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-1]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            if($Letters.$Letter.Width -lt $MaxWidth -and $Num -le ($Letters.$Letter.Lines - $WidestLetter.Lines) -and $Letter -ne "_"){
                                if(1..$WidestLetter.Lines -contains $Num){
                                    $PaddingDeficit = ' ' * (($MaxWidth - $Letters.$Letter.Width)) -as [String]
                                    $LineFragment = $PaddingDeficit + $LineFragment
                                }
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 7){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        foreach ($Num in 2..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-2]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 6){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        foreach ($Num in 3..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-3]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 5){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        $Lines.'3' += $Padding
                        foreach ($Num in 4..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-4]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 4){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        $Lines.'3' += $Padding
                        $Lines.'4' += $Padding
                        foreach ($Num in 5..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-5]
                            if($LineFragment.Length -lt $Letters.$Letter.Width){
                                $LineFragment += ' ' * ($Letters.$Letter.Width - $LineFragment.Length)
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    $LetterPos++
                } #End $LetterArray | ForEach-Object
            } # End If(Size -eq Large)
            
            $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | Where-Object { $_ -match '\S'} | ForEach-Object {
                $_
            }
        } #End Function fnGetAscii
        Function fnLetterXML{
            if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Letters)){
                $Script:Letters = @{}
            }
            $LetterFile = 'E:\Documents\GitHub\PSGame\Theodora\module\letters.xml'
            $LetterXML = [XML] (Get-Content $LetterFile)
            $LetterXML.Chars.Char | Foreach-Object {
                if($_.Name -ne 'template'){
                    $Letters."$($_.Name)" = New-Object PSObject -Property @{
                        'ASCII' = $_.Data
                        'Width' = $_.Width
                        'Lines' = $_.Lines
                        'Fixation' = $_.Fixation
                        'Size' = $_.Size
                        'Case' = $_.Case
                    }
                }
            }
        } # End fnLetterXML
        $LetterArray = [String[]]($Letters.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Name)
        $AcceptedChars = [regex] ( '(?i)[^' + ([regex]::Escape(($LetterArray -join '')) -replace '-', '\-' -replace '\]', '\]') + ' ]' )
    } # End Begin
    process{
        if($InputObject -match $AcceptedChars){
            "Unsupported Character."
            Return
        }
        $Lines = @()
        foreach ($Text in $InputObject) {
            $ASCII = fnGetAscii ($Text -replace ' ', '_') -Size $Size
            if($ForegroundColor -ne 'Default' -and $BackgroundColor -ne 'Default'){
                $ASCII | ForEach-Object {
                    Write-Host -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor ($ASCII -join "`n")
                }
            }
            elseif($ForegroundColor -ne 'Default'){
                Write-Host -ForegroundColor $ForegroundColor ($ASCII -join "`n")
            }
            elseif($BackgroundColor -ne 'Default'){
                Write-Host BackgroundColor $BackgroundColor ($ASCII -join "`n")
            }
            else{
                $ASCII -replace '\s+$'
            }
        }
    } # End Process
} # End Function

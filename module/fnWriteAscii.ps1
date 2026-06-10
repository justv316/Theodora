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
            if($Size -eq "Small"){
                #Create Fresh Variables
                $LetterPos = 0
                $LetterWidthArray = @()
                $LetterLinesArray = @()
                $TextLetterArray = @()
                $Lines = @{
                    '1' = ''
                    '2' = ''
                    '3' = ''
                    '4' = ''
                    '5' = ''
                    '6' = ''
                }
                #Populate the Arrays
                $LetterArray | Foreach-Object{
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ls$($_)"
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "us$($_)"
                    }
                    elseif($_ -eq "_"){
                        $Letter = "s$($_)"
                    }
                    $TextLetterArray  += $Letter
                    $LetterWidthArray += $Letters.$Letter.Width
                    $LetterLinesArray += $Letters.$Letter.Lines
                }
                $TextLetterArray | ForEach-Object {
                    $Letter = [String]$_
                    if($LetterLinesArray[$LetterPos] -eq 6){
                        foreach($Num in 1..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-1]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    elseif($LetterLinesArray[$LetterPos] -eq 5){
                        $Padding = ' ' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        foreach($Num in 2..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-2]
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
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                $LetterPos++
                }
            } # End If(Size -eq Small)
            if($Size -eq "Large"){
                #Create Fresh Variables
                $LetterPos = 0
                $LetterWidthArray = @()
                $LetterLinesArray = @()
                $TextLetterArray = @()
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
                #Populate the Arrays
                $LetterArray | Foreach-Object{
                    if($_ -match [Regex]('[a-z]')){
                        $Letter = "ll$($_)"
                    }
                    elseif($_ -match [Regex]('[A-Z]')){
                        $Letter = "ul$($_)"
                    }
                    elseif($_ -eq "_"){
                        $Letter = "$($_)"
                    }
                    $TextLetterArray  += $Letter
                    $LetterWidthArray += $Letters.$Letter.Width
                    $LetterLinesArray += $Letters.$Letter.Lines
                }
                #Populate the Lines
                $TextLetterArray | ForEach-Object {
                    $Letter = [String]$_
                    if($LetterLinesArray[$LetterPos] -eq 8){
                        foreach($Num in 1..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-1]
                            if($LetterPos -ne 0){
                                $CurrentCharacter = $Letter
                                $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                                $PreviousLetter = 
                                if($PreviousCharacter -eq "_"){
                                    "$($TextLetterArray[$LetterPos-2])"
                                }
                                else{
                                    "$($TextLetterArray[$LetterPos-1])"
                                }
                                $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [INT]
                                $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [INT]
                                $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [INT]
                                $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [INT]
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 2){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = ' ' * $PaddingDeficit
                                            }
                                            $LineFragment = $FragmentPadding + $LineFragment
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    if(1..$PreviousLetterLines -Contains $Num){
                                        $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                        if($PaddingDeficit -gt 0){
                                            $FragmentPadding = ' ' * $PaddingDeficit
                                        }
                                        $LineFragment = $FragmentPadding + $LineFragment
                                    }
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
                            if($LetterPos -ne 0){
                                $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                                $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                                $PreviousLetter = 
                                if($PreviousCharacter -eq "_"){
                                    "$($TextLetterArray[$LetterPos-2])"
                                }
                                else{
                                    "$($TextLetterArray[$LetterPos-1])"
                                }
                                $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [INT]
                                $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [INT]
                                $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [INT]
                                $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [INT]
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 2){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = ' ' * $PaddingDeficit
                                            }
                                            $LineFragment = $FragmentPadding + $LineFragment
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    if(1..$PreviousLetterLines -Contains $Num){
                                        $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                        if($PaddingDeficit -gt 0){
                                            $FragmentPadding = ' ' * $PaddingDeficit
                                        }
                                        $LineFragment = $FragmentPadding + $LineFragment
                                    }
                                }
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
                            if($LetterPos -ne 0){
                                $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                                $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                                $PreviousLetter = 
                                if($PreviousCharacter -eq "_"){
                                    "$($TextLetterArray[$LetterPos-2])"
                                }
                                else{
                                    "$($TextLetterArray[$LetterPos-1])"
                                }
                                $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [INT]
                                $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [INT]
                                $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [INT]
                                $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [INT]
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 2){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = ' ' * $PaddingDeficit
                                            }
                                            $LineFragment = $FragmentPadding + $LineFragment
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    if(1..$PreviousLetterLines -Contains $Num){
                                        $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                        if($PaddingDeficit -gt 0){
                                            $FragmentPadding = ' ' * $PaddingDeficit
                                        }
                                        $LineFragment = $FragmentPadding + $LineFragment
                                    }
                                }
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
                            if($LetterPos -ne 0){
                                $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                                $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                                $PreviousLetter = 
                                if($PreviousCharacter -eq "_"){
                                    "$($TextLetterArray[$LetterPos-2])"
                                }
                                else{
                                    "$($TextLetterArray[$LetterPos-1])"
                                }
                                $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [INT]
                                $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [INT]
                                $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [INT]
                                $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [INT]
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 2){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = ' ' * $PaddingDeficit
                                            }
                                            $LineFragment = $FragmentPadding + $LineFragment
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    if(1..$PreviousLetterLines -Contains $Num){
                                        $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                        if($PaddingDeficit -gt 0){
                                            $FragmentPadding = ' ' * $PaddingDeficit
                                        }
                                        $LineFragment = $FragmentPadding + $LineFragment
                                    }
                                }
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
                            if($LetterPos -ne 0){
                                $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                                $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                                $PreviousLetter = 
                                if($PreviousCharacter -eq "_"){
                                    "$($TextLetterArray[$LetterPos-2])"
                                }
                                else{
                                    "$($TextLetterArray[$LetterPos-1])"
                                }
                                $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [INT]
                                $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [INT]
                                $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [INT]
                                $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [INT]
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 2){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = ' ' * $PaddingDeficit
                                            }
                                            $LineFragment = $FragmentPadding + $LineFragment
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    if(1..$PreviousLetterLines -Contains $Num){
                                        $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                        if($PaddingDeficit -gt 0){
                                            $FragmentPadding = ' ' * $PaddingDeficit
                                        }
                                        $LineFragment = $FragmentPadding + $LineFragment
                                    }
                                }
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    $LetterPos++
                } #End $TextLetterArray | ForEach-Object
            } # End If(Size -eq Large)
            
            $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
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

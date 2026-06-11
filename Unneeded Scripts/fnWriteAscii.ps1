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
        Dont....Dont look at this....
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
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        foreach($Num in 2..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-2]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    elseif($LetterLinesArray[$LetterPos] -eq 4){
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        foreach($Num in 3..6){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-3]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    elseif($LetterLinesArray[$LetterPos] -eq 3){
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
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
                $TotalFragmentPadding = 0
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
                    if($Letters.$Letter.Lines -gt $MaxLines){
                        $Maxlines = $Letters.$Letter.Lines
                    }
                    if($Letters.$Letter.Lines -lt $MinLines){
                        $MinLines = $Letters.$Letter.Lines
                    }

                }
                #Populate the Lines
                $TextLetterArray | ForEach-Object {
                    $Letter = [String]$_
                    if($LetterLinesArray[$LetterPos] -eq 8){
                        $PaddingDeficit = 0
                        $FragmentPadding = ""
                        $AdditionalPadding = ""
                        $AdditionalPadding1 = ""
                        $CurrentCharacter = $Letter
                        $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                        $PreviousLetter = 
                        if($PreviousCharacter -eq "_"){
                            "$($TextLetterArray[$LetterPos-2])"
                        }
                        else{
                            "$($TextLetterArray[$LetterPos-1])"
                        }
                        if($PreviousCharacter -eq "_"){
                            $n = 2
                        }
                        else{
                            $n = 1
                        }
                        if($PreviousLetter -ne $CurrentCharacter){
                            $PreviousLetterCopies = 0
                            while($n -ne 0){
                                if($TextLetterArray[$LetterPos-$n] -eq $PreviousLetter){
                                    $PreviousLetterCopies++
                                    $n++
                                }
                                else{
                                    $n = 0
                                }
                            }
                            if($PreviousLetterCopies -gt 1){
                                $AdditionalPadding = 'a' * ($PreviousLetterCopies-1)
                            }
                            if($TotalFragmentPadding -eq 1){
                                $AdditionalPadding = 'a' * $TotalFragmentPadding
                            }
                            if($LastFragmentPadding -gt 0){
                                $AdditionalPadding = 'a' * $LastFragmentPadding
                            }
                        }
                        $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [int]
                        $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [int]
                        $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [int]
                        $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [int]
                        foreach($Num in 1..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-1]
                            if($LetterPos -ne 0){
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 7){
                        $PaddingDeficit = 0
                        $FragmentPadding = ""
                        $AdditionalPadding = ""
                        $AdditionalPadding1 = ""
                        $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                        $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                        $PreviousLetter = 
                        if($PreviousCharacter -eq "_"){
                            "$($TextLetterArray[$LetterPos-2])"
                        }
                        else{
                            "$($TextLetterArray[$LetterPos-1])"
                        }
                        if($PreviousCharacter -eq "_"){
                            $n = 2
                        }
                        else{
                            $n = 1
                        }
                        
                        if($PreviousLetter -ne $CurrentCharacter){
                            $PreviousLetterCopies = 0
                            while($n -ne 0){
                                if($TextLetterArray[$LetterPos-$n] -eq $PreviousLetter){
                                    $PreviousLetterCopies++
                                    $n++
                                }
                                else{
                                    $n = 0
                                }
                            }
                            if($PreviousLetterCopies -gt 1){
                                $AdditionalPadding = 'a' * ($PreviousLetterCopies-1)
                            }
                            if($TotalFragmentPadding -eq 1){
                                $AdditionalPadding = 'a' * $TotalFragmentPadding
                            }
                            if($LastFragmentPadding -gt 0){
                                $AdditionalPadding = 'a' * $LastFragmentPadding
                            }
                            if($MaxLines -gt 7 -and $MinLines -eq 4){
                                $AdditionalPadding1 = '1' * ($PreviousLetterCopies)
                                $Lines.'1' += $AdditionalPadding1
                            }
                        }
                        $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [int]
                        $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [int]
                        $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [int]
                        $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [int]
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        foreach ($Num in 2..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-2]
                            if($LetterPos -ne 0){
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 6){
                        $PaddingDeficit = 0
                        $FragmentPadding = ""
                        $AdditionalPadding = ""
                        $AdditionalPadding1 = ""
                        $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                        $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                        $PreviousLetter = 
                        if($PreviousCharacter -eq "_"){
                            "$($TextLetterArray[$LetterPos-2])"
                        }
                        else{
                            "$($TextLetterArray[$LetterPos-1])"
                        }
                        if($PreviousCharacter -eq "_"){
                            $n = 2
                        }
                        else{
                            $n = 1
                        }
                        
                        if($PreviousLetter -ne $CurrentCharacter){
                            $PreviousLetterCopies = 0
                            while($n -ne 0){
                                if($TextLetterArray[$LetterPos-$n] -eq $PreviousLetter){
                                    $PreviousLetterCopies++
                                    $n++
                                }
                                else{
                                    $n = 0
                                }
                            }
                            if($PreviousLetterCopies -gt 1){
                                $AdditionalPadding = 'a' * ($PreviousLetterCopies-1)
                            }
                            if($TotalFragmentPadding -eq 1){
                                $AdditionalPadding = 'a' * $TotalFragmentPadding
                            }
                            if($LastFragmentPadding -gt 0){
                                $AdditionalPadding = 'a' * $LastFragmentPadding
                            }
                            if($MaxLines -gt 6 -and $MinLines -eq 4){
                                $AdditionalPadding1 = '1' * ($PreviousLetterCopies)
                                $Lines.'1' += $AdditionalPadding1
                                $Lines.'2' += $AdditionalPadding1
                            }
                        }
                        $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [int]
                        $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [int]
                        $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [int]
                        $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [int]
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        foreach ($Num in 3..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-3]
                            if($LetterPos -ne 0){
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                    if($CurrentCharacterLines - $PreviousLetterLines -gt 0){
                                        if(1..(($CurrentCharacterLines - $PreviousLetterLines)+2) -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                    if($CurrentCharacterLines - $PreviousLetterLines -gt 0){
                                        if(1..(($CurrentCharacterLines - $PreviousLetterLines)+2) -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 5){
                        $PaddingDeficit = 0
                        $FragmentPadding = ""
                        $AdditionalPadding = ""
                        $AdditionalPadding1 = ""
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
                        $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                        $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                        $PreviousLetter = 
                        if($PreviousCharacter -eq "_"){
                            "$($TextLetterArray[$LetterPos-2])"
                        }
                        else{
                            "$($TextLetterArray[$LetterPos-1])"
                        }
                        if($PreviousCharacter -eq "_"){
                            $n = 2
                        }
                        else{
                            $n = 1
                        }
                        if($PreviousLetter -ne $CurrentCharacter){
                            $PreviousLetterCopies = 0
                            while($n -ne 0){
                                if($TextLetterArray[$LetterPos-$n] -eq $PreviousLetter){
                                    $PreviousLetterCopies++
                                    $n++
                                }
                                else{
                                    $n = 0
                                }
                            }
                            if($PreviousLetterCopies -gt 1){
                                $AdditionalPadding = 'a' * ($PreviousLetterCopies-1)
                            }
                            if($MaxLines -gt 5 -and $MinLines -eq 4){
                                $AdditionalPadding1 = '1' * ($PreviousLetterCopies)
                                $Lines.'1' += $AdditionalPadding1
                                $Lines.'2' += $AdditionalPadding1
                                $Lines.'3' += $AdditionalPadding1
                            }
                        }
                        $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [int]
                        $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [int]
                        $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [int]
                        $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [int]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        $Lines.'3' += $Padding
                        foreach ($Num in 4..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-4]
                            if($LetterPos -ne 0){
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 0){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            if($PaddingDeficit -lt 0){
                                                $FragmentPadding = 'f' * 1
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                            }
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLinesArray[$LetterPos] -eq 4){
                        $PaddingDeficit = 0
                        $FragmentPadding = ""
                        $AdditionalPadding = ""
                        $AdditionalPadding1 = ""
                        $CurrentCharacter = "$($TextLetterArray[$LetterPos])"
                        $PreviousCharacter = "$($TextLetterArray[$LetterPos-1])"
                        $PreviousLetter = 
                        if($PreviousCharacter -eq "_"){
                            "$($TextLetterArray[$LetterPos-2])"
                        }
                        else{
                            "$($TextLetterArray[$LetterPos-1])"
                        }
                        $CurrentCharacterWidth = $Letters.$CurrentCharacter.Width -as [int]
                        $PreviousLetterWidth = $Letters.$PreviousLetter.Width -as [int]
                        $CurrentCharacterLines = $Letters.$CurrentCharacter.Lines -as [int]
                        $PreviousLetterLines = $Letters.$PreviousLetter.Lines -as [int]
                        $Padding = 'p' * $LetterWidthArray[$LetterPos]
                        $Lines.'1' += $Padding
                        $Lines.'2' += $Padding
                        $Lines.'3' += $Padding
                        $Lines.'4' += $Padding
                        foreach ($Num in 5..8){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-5]
                            if($LetterPos -ne 0){
                                if($CurrentCharacterWidth -lt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    If($CurrentCharacterLines - $PreviousLetterLines -gt 3){
                                        if(1..$PreviousLetterLines -Contains $Num){
                                            $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                            if($PaddingDeficit -gt 0){
                                                $FragmentPadding = 'f' * $PaddingDeficit
                                            }
                                            $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                            $TotalFragmentPadding++
                                            $LastFragmentPadding = $FragmentPadding.Length
                                        }
                                    }
                                }
                                elseif($CurrentCharacterWidth -gt $PreviousLetterWidth -and $CurrentCharacterLines -gt $PreviousLetterLines -and $CurrentCharacter -ne "_"){
                                    if(1..$PreviousLetterLines -Contains $Num){
                                        $PaddingDeficit = $PreviousLetterWidth - $CurrentCharacterWidth
                                        if($PaddingDeficit -gt 0){
                                            $FragmentPadding = 'f' * $PaddingDeficit
                                        }
                                        $LineFragment = $AdditionalPadding + $FragmentPadding + $LineFragment
                                        $TotalFragmentPadding++
                                        $LastFragmentPadding = $FragmentPadding.Length
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
         # End fnLetterXML
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

function fnGetAscii {
    param(
        [String] $InputObject,
        [ValidateSet("Large","Small")]
        [String] $Size
    )
    begin{
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Letters)){
            fnLetterXML
        }
        #Create Fresh Variables
        $Text = $InputObject -replace ' ','_'
        $LetterArray = [Char[]] $Text
        $MaxWidth = 0
        $MaxLines = 0
        $LetterWidthArray = @()
        $LetterLinesArray = @()
        $TextLetterArray = @()
        $Lines = [System.Collections.SortedList]::new()
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
            if(($Letters.$Letter.Width -as [int]) -gt $MaxWidth){
                $MaxWidth = $Letters.$Letter.Width
            }
            if(($Letters.$Letter.Lines -as [int]) -gt $MaxLines){
                $MaxLines = $Letters.$Letter.Lines
            }
            $TextLetterArray  += $Letter
            $LetterWidthArray += $Letters.$Letter.Width -as [int]
            $LetterLinesArray += $Letters.$Letter.Lines -as [int]
        }
        #Create a line hash that is how many lines we need
        foreach($Num in 1..$MaxLines){
            $Lines["$($Num)"] = ("")
        }
        #A set offset is required to print letters in their correct space. This will be used in place of a mathematical function that determines it, for now.
        $MaxLineStr = $MaxLines -as [String]
        $FourLineOffsetHash = @{
            "8" = -1
            "7" = 0
            "6" = 1
            "5" = 2
        }
        $FiveLineOffsetHash = @{
            "8" = 1
            "6" = 3
        }
        #Populate the Lines Hash
        $TextLetterArray | Foreach-Object {
            $Letter = [String]$_
            $LetterLines = $Letters.$Letter.Lines -as [int]
            $LetterWidth = $Letters.$Letter.Width -as [int]
            #If the character is not a space
            if($Letter -ne "_"){
                if($LetterLines -lt $MaxLines){
                    foreach($Num in 1..($MaxLines-$LetterLines)){
                        $Padding = ' ' * ($LetterWidth)
                        $StringNum = [String] $Num
                        $Lines.$StringNum += $Padding
                    }
                    if($LetterLines -eq 4){
                        foreach($Num in ($LetterLines - $FourLineOffsetHash["$MaxLineStr"])..$MaxLines){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines - $FourLineOffsetHash["$MaxLineStr"])]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLines -eq 5){
                        foreach($Num in ($LetterLines - $FiveLineOffsetHash["$MaxLineStr"])..$MaxLines){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines - $FiveLineOffsetHash["$MaxLineStr"])]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLines -eq 6){
                        foreach($Num in ($LetterLines - 3)..$MaxLines){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines - 3)]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                }
                elseif($LetterLines -eq $MaxLines){
                    foreach($Num in 1..$MaxLines){
                        $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines + 1)]
                        $StringNum = [String] $Num
                        $Lines.$StringNum += $LineFragment
                    }
                }
            }
            #Create space padding
            elseif($Letter -eq "_"){
                foreach($Num in 1..$MaxLines){
                    $Padding = ' ' * 4
                    $StringNum = [String] $Num
                    $Lines.$StringNum += $Padding
                }
            }
        }
        
    } #End Begin
    process{
        $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
            $_
        }
    } #end process
} #end function

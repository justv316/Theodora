function fnGetAscii {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("Large","Small")]
        [String] $Font
    )
    begin{
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Letters)){
            fnLetterXML
        }
        #Create Fresh Variables
        $Text = $InputObject -replace ' ','¤'
        $LetterArray = [Char[]] $Text
        $MaxLines = 0
        $TextLetterArray = @()
        $Lines = [System.Collections.SortedList]::new()
        #Populate the Arrays
        $LetterArray | Foreach-Object{
            if($Font -eq "Large"){
                if($_ -match [Regex]('[a-z]')){
                    $Letter = "ll$($_)"
                }
                elseif($_ -match [Regex]('[A-Z]')){
                    $Letter = "ul$($_)"
                }
                elseif($_ -match [Regex]('\d+') -or $_ -match [Regex]('\p{P}') -or $_ -match [Regex]('\p{S}') -and $_ -ne "&" -and $_ -ne "¤"){
                    $Letter = "l$($_)"
                }
                elseif($_ -eq "¤"){
                    $Letter = "$_"
                }
                elseif($_ -eq "&"){
                    $Letter = "lamp"
                }
            }
            elseif($Font -eq "Small"){
                if($_ -match [Regex]('[a-z]')){
                    $Letter = "ls$($_)"
                }
                elseif($_ -match [Regex]('[A-Z]')){
                    $Letter = "us$($_)"
                }
                elseif($_ -match [Regex]('\d+') -or $_ -match [Regex]('\p{P}') -or $_ -match [Regex]('\p{S}') -and $_ -ne "&" -and $_ -ne "¤"){
                    $Letter = "s$($_)"
                }
                elseif($_ -eq "¤"){
                    $Letter = "$_"
                }
                elseif($_ -eq "&"){
                    $Letter = "samp"
                }
            }
            if(($Letters.$Letter.Lines -as [int]) -gt $MaxLines){
                $MaxLines = $Letters.$Letter.Lines
            }
            $TextLetterArray  += $Letter
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
            "7" = 2
            "6" = 3
        }
        $SixLineOffsetHash = @{
            "8" = 3
            "7" = 4
        }
        #Populate the Lines Hash
        $TextLetterArray | Foreach-Object {
            $Letter = [String]$_
            $LetterLines = $Letters.$Letter.Lines -as [int]
            $LetterWidth = $Letters.$Letter.Width -as [int]
            #If the character is not a space
            if($Letter -ne "¤"){
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
                        foreach($Num in ($LetterLines - $SixLineOffsetHash["$MaxLineStr"])..$MaxLines){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines - $SixLineOffsetHash["$MaxLineStr"])]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                    if($LetterLines -eq 7){
                        foreach($Num in ($LetterLines - 5)..$MaxLines){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines - 5)]
                            $StringNum = [String] $Num
                            $Lines.$StringNum += $LineFragment
                        }
                    }
                }
                elseif($LetterLines -eq $MaxLines){
                    foreach($Num in 1..$MaxLines){
                        $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num - 1]
                        $StringNum = [String] $Num
                        $Lines.$StringNum += $LineFragment
                    }
                }
            }
            #Create space padding
            elseif($Letter -eq "¤"){
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

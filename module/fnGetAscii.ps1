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
            fnXMLLetter
        }
        #Create Fresh Variables
        $SubLineCount = 0
        $WrapReg = "(\S{$($ASCIIMax),}|.{1,$($ASCIIMax)})(?:\s|$)"
        $Reg = $InputObject | Select-String -AllMatches -Pattern $WrapReg
        $CountTextGroups = $Reg.Matches.Count
        $TextGroups = [System.Collections.SortedList]::new()
        foreach($Num in 1..$CountTextGroups){
            $TextGroups[$Num] = @{
                Text = @()
                MaxLines = 0
                MaxWidth = 0
            }
        }
        $StringPos = 1
        if($Font -eq "Large"){
            $FontC = "l"
        }
        elseif($Font -eq "Small"){
            $FontC = "s"
        }
        $Strings = $Reg.Matches | Foreach-Object{$_.Value}
        $Strings | Foreach-Object{
            $LetterArray = [Char[]] $_
            foreach($Character in $LetterArray){
                if($Character -match [Regex]('[a-z]')){
                    $Letter = "l$($FontC)$($Character)"
                }
                elseif($Character -match [Regex]('[A-Z]')){
                    $Letter = "u$($FontC)$($Character)"
                }
                elseif($Character -match [Regex]('\d+') -or $Character -match [Regex]('\p{P}') -or $Character -match [Regex]('\p{S}') -and $Character -ne "&" -and $Character -ne "¤"){
                    $Letter = "$($FontC)$($Character)"
                }
                elseif($Character -eq " "){
                    $Letter = "¤"
                }
                elseif($Character -eq "&"){
                    $Letter = "$($FontC)amp"
                }
                if(($Letters.$Letter.Width -as [int]) -gt $TextGroups[$StringPos].MaxWidth){
                    $TextGroups[$StringPos].MaxWidth = $Letters.$Letter.Width -as [Int]
                }
                if(($Letters.$Letter.Lines -as [int]) -gt $TextGroups[$StringPos].MaxLines){
                    $TextGroups[$StringPos].MaxLines = $Letters.$Letter.Lines -as [int]
                }
                $TextGroups[$StringPos].Text += $Letter
            }
            $StringPos++
        }
        foreach($num in 1..$CountTextGroups){
            $Textgroups[$Num] | Foreach-Object{
                $SubLineCount += $_.MaxLines
            }
        }
        $Lines = [System.Collections.SortedList]::new()
        foreach($Num in 1..($SubLineCount)){
            $Lines[$Num] = ("")
        }
        #Populate the Lines Hash
        foreach($GroupNum in 1..$CountTextGroups){
            $TextGroups[$GroupNum].Text | Foreach-Object{
                $Letter = [String]$_
                $LetterLines = $Letters.$Letter.Lines -as [int]
                $LetterWidth = $Letters.$Letter.Width -as [int]
                $Offset = ($LetterLines * 2) - ($TextGroups[$GroupNum].MaxLines) - 1
                $StartLine = 1
                $LastLine = $TextGroups[$GroupNum].MaxLines * $GroupNum
                if($Letter -ne "¤"){
                    if($LetterLines -lt $TextGroups[$GroupNum].MaxLines){
                        #Create Padding above the character to the maxline
                        foreach($Num in $StartLine..($TextGroups[$GroupNum].MaxLines - $LetterLines)){
                            $Padding = ' ' * ($LetterWidth)
                            $Lines[$Num] += $Padding
                        }
                        foreach($Num in (($LetterLines - $Offset)..$LastLine)){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num-($LetterLines - $Offset)]
                            $Lines[$Num] += $LineFragment
                        }
                    }
                    elseif($LetterLines -eq $TextGroups[$GroupNum].MaxLines){
                        foreach($Num in 1..$TextGroups[$GroupNum].MaxLines){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$Num - 1]
                            $Lines[$Num] += $LineFragment
                        }
                    }
                }
                #Create space padding
                elseif($Letter -eq "¤"){
                    foreach($Num in 1..$TextGroups[$GroupNum].MaxLines){
                        $Padding = ' ' * 4
                        $Lines[$Num] += $Padding
                    }
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

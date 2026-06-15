function fnGetAscii {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("Large","Small")]
        [String] $Font,
        [Parameter(Mandatory=$True,Position=2)]
        [String]$BuildType,
        [Parameter(Position=3)]
        [int] $EnforcedMaxLength = 160,
        [Parameter(Position=4)]
        [int] $MinimumPaddingLength = 4
    )
    begin{
        #Create Fresh Variables
        if($Font -eq "Large"){
            $FontC = "l"
        }
        elseif($Font -eq "Small"){
            $FontC = "s"
        }
        $ASCIIMax = [Math]::Ceiling((($EnforcedMaxLength) - ($MinimumPaddingLength * 2) - (($Boxes["$($BuildType)"])["BorderLines"])) / 10)
        $SubLineCount = 0
        $WrapReg = "(\S{$($ASCIIMax),}|.{1,$($ASCIIMax)})(?:\s|$)"
        $Reg = $InputObject | Select-String -AllMatches -Pattern $WrapReg
        $CountTextGroups = $Reg.Matches.Count
        $TextGroups = [System.Collections.SortedList]::new()
        foreach($Num in 1..$CountTextGroups){
            $TextGroups[$Num] = @{
                Text = [System.Collections.ArrayList]@()
                MaxLines = 0
                MaxWidth = 0
            }
        }
        $StringPos = 1
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
                if($TextGroups[$Num].Text[-1] -eq "¤"){
                    $Arr = $TextGroups[$Num].Text
                    $TextGroups[$Num].Text = $Arr[0..($Arr.Count - 2)]
                }
            }
        }
        $Lines = [System.Collections.SortedList]::new()
        foreach($Num in 1..($SubLineCount)){
            $Lines[$Num] = ("")
        }
        $StartLine = 1
        foreach($GroupNum in 1..$CountTextGroups){
            $Textgroups[$GroupNum].Text | Foreach-Object{
                $Letter = [String]$_
                $LetterLines = $Letters.$Letter.Lines -as [int]
                $LetterWidth = $Letters.$Letter.Width -as [int]
                $LastLine = $TextGroups[$GroupNum].MaxLines * $GroupNum
                $LineIndex = 0
                $CountPadding = 0
                if($Letter -ne "¤"){
                    if($LetterLines -lt $TextGroups[$GroupNum].MaxLines){
                        foreach($Num in $StartLine..($LastLine - $LetterLines)){
                            $Padding = ' ' * $LetterWidth
                            $Lines[$Num] += $Padding
                            $CountPadding++
                        }
                        foreach($Num in ($StartLine + $CountPadding)..$LastLine){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$LineIndex]
                            $Lines[$Num] += $LineFragment
                            $LineIndex++
                        }
                    }
                    elseif($LetterLines -eq $TextGroups[$GroupNum].MaxLines){
                        foreach($Num in $StartLine..$LastLine){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$LineIndex]
                            $Lines[$Num] += $LineFragment
                            $LineIndex++
                        }
                    }
                }
                elseif($Letter -eq "¤"){
                    foreach($Num in $StartLine..$LastLine){
                        $Padding = ' ' * 4
                        $Lines[$Num] += $Padding
                    }
                }
            }
            $StartLine += $TextGroups[$GroupNum].MaxLines
        }
    } #End Begin
    process{
        $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
            $_
        }
    } #end process
} #end function

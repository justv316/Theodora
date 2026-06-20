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
        # Variables
        $StringPos = 1
        $SubLineCount = 0
        $FontC = if($Font -eq "Large"){"l"}elseif($Font -eq "Small"){"s"}
        $ASCIIMax = [Math]::Ceiling((($EnforcedMaxLength) - ($MinimumPaddingLength * 2) - (($Boxes["$($BuildType)"])["BorderLines"])) / 10)
        $Reg = $InputObject | Select-String -AllMatches -Pattern "(\S{$($ASCIIMax),}|.{1,$($ASCIIMax)})(?:\s|$)"
        $CountTextGroups = $Reg.Matches.Count
        # Create Text Groups
        $TextGroups = [System.Collections.SortedList]::new()
        foreach($Num in 1..$CountTextGroups){
            $TextGroups[$Num] = @{
                Text = [System.Collections.ArrayList]@()
                MaxLines = 0
                MaxWidth = 0
            }
        }
        # Populate Text Groups with letters that can be used to search the letters xml
        $Strings = $Reg.Matches | Foreach-Object{$_.Value}
        $Strings | Foreach-Object{
            $LetterArray = [Char[]] $_
            foreach($Character in $LetterArray){
                $Letter = 
                if($Character -match [Regex]('[a-z]')){"l$($FontC)$($Character)"}
                elseif($Character -match [Regex]('[A-Z]')){"u$($FontC)$($Character)"}
                elseif($Character -match [Regex]('\d+') -or $Character -match [Regex]('\p{P}') -or $Character -match [Regex]('\p{S}') -and $Character -ne "&" -and $Character -ne "¤"){"$($FontC)$($Character)"}
                elseif($Character -eq " "){"¤"}
                elseif($Character -eq "&"){"$($FontC)amp"}
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
        # Find the total line count, and trim spaces from the end
        foreach($num in 1..$CountTextGroups){
            $Textgroups[$Num] | Foreach-Object{
                $SubLineCount += $_.MaxLines
                if($TextGroups[$Num].Text[-1] -eq "¤"){
                    $Arr = $TextGroups[$Num].Text
                    $TextGroups[$Num].Text = $Arr[0..($Arr.Count - 2)]
                }
            }
        }
        # Create the Lines List
        $Lines = [System.Collections.SortedList]::new()
        foreach($Num in 1..($SubLineCount)){
            $Lines[$Num] = ("")
        }
        # Populate the Lines with ASCII Fragments
        $StartLine = 1
        foreach($GroupNum in 1..$CountTextGroups){
            $LineHeight = $TextGroups[$GroupNum].MaxLines
            $EndLine = $StartLine + $Lineheight - 1
            $Textgroups[$GroupNum].Text | Foreach-Object{
                $Letter = [String]$_
                $LetterLines = [Int]$Letters.$Letter.Lines
                $LetterWidth = [Int]$Letters.$Letter.Width
                $CountPadding = 0
                $LineIndex = 0
                if($Letter -ne "¤"){
                    if($LetterLines -lt $LineHeight){
                        foreach($Num in $StartLine..($EndLine - $LetterLines)){
                            $Padding = ' ' * $LetterWidth
                            $Lines[$Num] += $Padding
                            $CountPadding++
                        }
                        foreach($Num in ($StartLine + $CountPadding)..$EndLine){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$LineIndex]
                            $Lines[$Num] += $LineFragment
                            $LineIndex++
                        }
                    }
                    elseif($LetterLines -eq $LineHeight){
                        foreach($Num in $StartLine..$EndLine){
                            $LineFragment = [String](($Letters.$Letter.ASCII).Split("`n"))[$LineIndex]
                            $Lines[$Num] += $LineFragment
                            $LineIndex++
                        }
                    }
                }
                elseif($Letter -eq "¤"){
                    foreach($Num in $StartLine..$EndLine){
                        $Padding = ' ' * 4
                        $Lines[$Num] += $Padding
                    }
                }
            }
            $StartLine += $TextGroups[$GroupNum].MaxLines
        }
    } # End Begin
    process{
        $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
            $_
        }
    } #end process
}
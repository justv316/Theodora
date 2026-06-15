function fnBuildASCII{
    [CmdletBinding()]
    param(
        [Array]$ASCII,
        [String]$BuildType,
        [ValidateSet("Center","Left","Right","None")]
        [String] $Justification = "Center",
        [String] $Padding = ' ',
        [Switch] $Segmented,
        [int]$EnforcedMaxLength = 160,
        [int]$MinimumPaddingLength = 4
    )

    begin{
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters)){
            fnXMLCharacter
        }
        #We need to reference this hash table later, so making it persist while the module is active
        $Script:Boxes = @{
            "SingleBox" = @{
            "BorderLines" = 2
            "OuterBorderLines" = 1
            "OuterBorder" = $Characters.SingleVertical
            "OuterHorizontalBorder" = $Characters.SingleHorizontal
            "OuterTopBorderLC" = $Characters.SingleTopLeftCorner
            "OuterTopBorderRC" = $Characters.SingleTopRightCorner
            "OuterBottomBorderLC" = $Characters.SingleBottomLeftCorner
            "OuterBottomBorderRC" = $Characters.SingleBottomRightCorner
            "LeftBorder" = $Characters.SingleVertical
            "RightBorder" = $Characters.SingleVertical
            }
            "DoubleBox" = @{
            "BorderLines" = 2
            "OuterBorderLines" = 1
            "OuterBorder" = $Characters.DoubleVertical
            "OuterHorizontalBorder" = $Characters.DoubleHorizontal
            "OuterTopBorderLC" = $Characters.DoubleTopLeftCorner
            "OuterTopBorderRC" = $Characters.DoubleTopRightCorner
            "OuterBottomBorderLC" = $Characters.DoubleBottomLeftCorner
            "OuterBottomBorderRC" = $Characters.DoubleBottomRightCorner
            "LeftBorder" = $Characters.DoubleVertical
            "RightBorder" = $Characters.DoubleVertical
            }
            "SingleDoubleBox" = @{
            "BorderLines" = 4
            "OuterBorderLines" = 2
            "OuterBorder" = $Characters.DoubleVertical
            "OuterHorizontalBorder" = $Characters.DoubleHorizontal
            "OuterTopBorderLC" = $Characters.DoubleTopLeftCorner
            "OuterTopBorderRC" = $Characters.DoubleTopRightCorner
            "OuterBottomBorderLC" = $Characters.DoubleBottomLeftCorner
            "OuterBottomBorderRC" = $Characters.DoubleBottomRightCorner
            "InnerBorder" = $Characters.SingleVertical
            "InnerHorizontalBorder" = $Characters.SingleHorizontal
            "InnerTopBorderLC" = $Characters.SingleTopLeftCorner
            "InnerTopBorderRC" = $Characters.SingleTopRightCorner
            "InnerBottomBorderLC" = $Characters.SingleBottomLeftCorner
            "InnerBottomBorderRC" = $Characters.SingleBottomRightCorner
            "LeftBorder" = $Characters.DoubleVertical + $Characters.SingleVertical
            "RightBorder" = $Characters.SingleVertical + $Characters.DoubleVertical
            }
        }
        $Build = ($Boxes[$($BuildType)])
        $BuildLines = ($Boxes[$($BuildType)])["BorderLines"]
        $OuterBuildLines = ($Boxes[$($BuildType)])["OuterBorderLines"]
        $Lines = [System.Collections.SortedList]::new()
        $MaxLines = $ASCII.Count
        $MaxLineWidth = 0
        #Create a Line Hashtable that is exactly the number of lines we need
        #If we're sending a segmented hash, we need 3 lines for each Text Line. (Left Padding, Segment, Right Padding.)
        if($Segmented){
            foreach($Num in 1..(($MaxLines * 3) + $BuildLines)){
                $Lines[$($Num)] = ("")
            }
        }
        else{
            foreach($Num in 1..($MaxLines + $BuildLines)){
                $Lines[$($Num)] = ("")
            }
        }
        #Find the Widest Line for both emergency padding purposes, and to properly align the border in None-type Justification
        foreach($Line in $ASCII){
            if($Line.Length -gt $MaxLineWidth){
                $MaxLineWidth = $Line.Length
            }
        }
        #Create Border Lines
        if($Justification -eq "None"){
            $EnforcedMaxLength = $MaxLineWidth + $OuterBuildLines
            $TopBorder = ($Build["OuterTopBorderLC"]) + (($Build["OuterHorizontalBorder"])*($EnforcedMaxLength)) + ($Build["OuterTopBorderRC"])
            $BottomBorder = ($Build["OuterBottomBorderLC"]) + (($Build["OuterHorizontalBorder"])*($EnforcedMaxLength)) + ($Build["OuterBottomBorderRC"])
            if($BuildLines -eq 4){
                $InnerTopBorder = ($Build["OuterBorder"]) + ($Build["InnerTopBorderLC"]) + (($Build["InnerHorizontalBorder"])*($EnforcedMaxLength - $OuterBuildLines)) + ($Build["InnerTopBorderRC"]) + ($Build["OuterBorder"])
                $InnerBottomBorder = ($Build["OuterBorder"]) + ($Build["InnerBottomBorderLC"]) + (($Build["InnerHorizontalBorder"])*($EnforcedMaxLength - $OuterBuildLines)) + ($Build["InnerBottomBorderRC"]) + ($Build["OuterBorder"])
            }
        }
        else{
            $TopBorder = ($Build["OuterTopBorderLC"]) + (($Build["OuterHorizontalBorder"])*($EnforcedMaxLength-$OuterBuildLines)) + ($Build["OuterTopBorderRC"])
            $BottomBorder = ($Build["OuterBottomBorderLC"]) + (($Build["OuterHorizontalBorder"])*($EnforcedMaxLength-$OuterBuildLines)) + ($Build["OuterBottomBorderRC"])
            if($BuildLines -eq 4){
                $InnerTopBorder = ($Build["OuterBorder"]) + ($Build["InnerTopBorderLC"]) + (($Build["InnerHorizontalBorder"])*($EnforcedMaxLength-$BuildLines)) + ($Build["InnerTopBorderRC"]) + ($Build["OuterBorder"])
                $InnerBottomBorder = ($Build["OuterBorder"]) + ($Build["InnerBottomBorderLC"]) + (($Build["InnerHorizontalBorder"])*($EnforcedMaxLength-$BuildLines)) + ($Build["InnerBottomBorderRC"]) + ($Build["OuterBorder"])
            }
        }
        #Adding the BorderLines is the same if segmented or not
        $Lines[1] += $TopBorder
        $Lines[($Lines.Count)] += $BottomBorder
        if($BuildLines -eq 4){
            $Lines[2] += $InnerTopBorder
            $Lines[($Lines.Count - 1)] += $InnerBottomBorder
        }
    }
    process{
        #Fill the Lines Array with Assembled Segments
        $Start = ($OuterBuildLines + 1)
        $End = (($Lines.Count) - $OuterBuildLines)
        $Counter = 0
        $Counter2 = 0
        Foreach($Num in $Start..$End){
            if($Segmented){
                $Segment = $ASCII[$Counter2]
            }
            else{
                $Segment = $ASCII[$Num-$Start]
            }
            #Determine Segment Padding Needed
            if($Justification -eq "Center"){
                $LeftPaddingRequired = (($EnforcedMaxLength / 2) - ($Build["LeftBorder"]).Length) - ($Segment.Length / 2)
                $RightPaddingRequired = (($EnforcedMaxLength / 2) - ($Build["RightBorder"]).Length) - ($Segment.Length / 2)
                $RightPaddingRequired = [Math]::floor($RightPaddingRequired)
                $LeftPaddingRequired = [Math]::ceiling($LeftPaddingRequired)
            }
            elseif($Justification -eq "Left"){
                $LeftPaddingRequired = $MinimumPaddingLength
                $RightPaddingRequired = ($EnforcedMaxLength - $Segment.Length - (($Build["RightBorder"]).Length + ($Build["LeftBorder"]).Length)) - $LeftPaddingRequired
            }
            elseif($Justification -eq "Right"){
                $RightPaddingRequired = $MinimumPaddingLength
                $LeftPaddingRequired = ($EnforcedMaxLength - $Segment.Length - (($Build["RightBorder"]).Length + ($Build["LeftBorder"]).Length)) - $RightPaddingRequired
            }
            elseif($Justification -eq "None"){
                $RightPaddingRequired = $MaxLineWidth - $Segment.Length
                $LeftPaddingRequired = 0
            }
            if($OuterBuildLines -eq 1){
                $RightPaddingRequired = [Math]::ceiling($RightPaddingRequired) + 1
            }
            $RightPadding = (("$($Padding)") * ($RightPaddingRequired)) + ($Build["RightBorder"])
            $LeftPadding = ($Build["LeftBorder"]) + (("$($Padding)") * ($LeftPaddingRequired))
            if($Segmented){
                if($Counter -le 2){
                    if($Counter2 -le $Maxlines){
                        if($Counter -eq 0){
                            $Lines[$Num] += $LeftPadding
                            $Counter++
                        }
                        elseif($Counter -eq 1){
                            $Lines[$Num] += $ASCII[$Counter2]
                            $Counter++
                        }
                        elseif($Counter -eq 2){
                            $Lines[$Num] += $RightPadding  
                            $Counter = 0
                            $Counter2++
                        }
                    }
                }
            }
            else{
                $AssembledSegment = $LeftPadding + $Segment + $RightPadding
                $Lines[$Num] += $AssembledSegment
            }

        }
        #Return the Output
        $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
            $_
        }
    } #end process
}
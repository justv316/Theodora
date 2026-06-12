function fnBuildASCII{
    [CmdletBinding()]
    param(
        [Array]$ASCII,
        [String]$BuildType,
        [ValidateSet("Center","Left","Right","None")]
        [String] $Justification = "Center",
        [String] $Padding = ' ',
        [int]$EnforcedMaxLength = 160,
        [int]$MinimumPaddingLength = 4
    )

    begin{
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters)){
            fnXMLCharacter
        }
        $Boxes = @{
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
        $MaxWidth = 0
        foreach($Num in 1..($MaxLines + $BuildLines)){
            $Lines[$($Num)] = ("")
        }
        foreach($Line in $ASCII){
            if($Line.Length -gt $MaxWidth){
                $MaxWidth = $Line.Length
            }
        }
        
    }
    process{
        #Populate Border Lines
        if($Justification -eq "None"){
            $EnforcedMaxLength = $MaxWidth + $OuterBuildLines
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
        $Lines[1] += $TopBorder
        $Lines[($Maxlines + $BuildLines)] += $BottomBorder
        if($BuildLines -eq 4){
            $Lines[2] += $InnerTopBorder
            $Lines[(($Maxlines + $BuildLines)-1)] += $InnerBottomBorder
        }
        #Fill the Lines Array with Assembled Segments
        $Start = ($OuterBuildLines + 1)
        $End = (($BuildLines + $MaxLines) - $OuterBuildLines)
        Foreach($Num in $Start..$End){
            $Segment = $ASCII[$Num-$Start]
            #Determine Segment Padding Needed
            if($Justification -eq "Center"){
                $LeftPaddingRequired = (($EnforcedMaxLength) - (($Build["LeftBorder"]).Length) - (($Build["RightBorder"]).Length) - $Segment.Length) / 2
                $RightPaddingRequired = (($EnforcedMaxLength) - (($Build["LeftBorder"]).Length) - (($Build["RightBorder"]).Length) - $Segment.Length) / 2
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
                $RightPaddingRequired = $MaxWidth - $Segment.Length
                $LeftPaddingRequired = 0
            }
            if($OuterBuildLines -eq 1){
                $RightPaddingRequired = [Math]::ceiling($RightPaddingRequired) + 1
            }
            $RightPadding = ("$($Padding)") * ($RightPaddingRequired)
            $LeftPadding = ("$($Padding)") * ($LeftPaddingRequired)
            $AssembledSegment = ($Build["LeftBorder"]) + $LeftPadding + $Segment + $RightPadding + ($Build["RightBorder"])
            $Lines[$Num] += $AssembledSegment
        }

        #Return the Output
        $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
            $_
        }
    } #end process
}
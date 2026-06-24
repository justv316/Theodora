function fnBuildObject{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Array]$InputObject,
        [String]$BuildFormatting,
        [String]$BorderType,
        [int] $EnforcedMaxLength = 160,
        [int] $MinimumPaddingLength = 4
    )
    begin{
        # Argument Parsing
        $BuildParamArr = $BuildFormatting -Split ' '
        $BuildParam = ConvertTo-Params $BuildParamArr -schema @{
            ObjectType = [String],''
            BorderType = [String],'Single'
            Justification = [String], 'None'
            IgnoreTop = [Switch], $false
            MiddleBorder = [Switch], $false
            EnforcedMaxLength = [Int],160
            MinimumPaddingLength = [Int],4
            Padding = [String],' '
        }
        $BuildParamHash = @{}
        $BuildParamKeys = $BuildParam.Keys
        Foreach($Key in $BuildParamKeys){
            $BuildParamHash["$Key"] = $BuildParam[$Key].Value
        }
        $ObjectType = If($Null -ne $BuildParamHash["ObjectType"]){$BuildParamHash["ObjectType"]}elseif($Null -eq $BuildParamHash["ObjectType"]){throw "ObjectType is Required."}
        $BorderType = if($Null -ne $BuildParamHash["BorderType"]){$BuildParamHash["BorderType"]}else{"Single"}
        $Justification = if($Null -ne $BuildParamHash["Justification"]){$BuildParamHash["Justification"]}else{"None"}
        $IgnoreTop = If($Null -ne $BuildParamHash["IgnoreTop"]){$True}else{$False}
        $MiddleBorder = If($Null -ne $BuildParamHash["MiddleBorder"]){$True}else{$False}
        $EnforcedMaxLength = if($BuildParamHash["EnforcedMaxLength"] -ne 160 -and $Null -ne $BuildParamHash["EnforcedMaxLength"]){$BuildParamHash["EnforcedMaxLength"]}else{160}
        $MinimumPaddingLength = if($BuildParamHash["MinimumPaddingLength"] -ne 4 -and $Null -ne $BuildParamHash["MinimumPaddingLength"]){$BuildParamHash["MinimumPaddingLength"]}else{4}
        $Padding = if($BuildParamHash["Padding"]){$BuildParamHash["Padding"]}else{" "}
    # End Argument Parsing
        if($ObjectType -eq "Boxed"){
            $Build = ($Boxes[$($BorderType)])
            $BorderLineCount = $Build.Vertical.Length * 2
            $OuterBuildLines = $Build.Vertical.Length
            $Lines = [System.Collections.SortedList]::new()
            $MaxLines = $InputObject.Count
            $MaxLineWidth = 0
            foreach($Num in 1..($MaxLines + $BorderLineCount)){
                $Lines[$($Num)] = ("")
            }
            foreach($Line in $InputObject){
                if($Line.Length -gt $MaxLineWidth){
                    $MaxLineWidth = $Line.Length
                }
            }

            $PaddingMultiplier = 
                if($Justification -eq "None"){$MaxLineWidth + $BorderLineCount}
                else{$EnforcedMaxLength - $OuterBuildLines}
            $Lines[1] = 
                if($IgnoreTop -eq $True){($Build["Vertical"]) + (($Padding) * $PaddingMultiplier) + ($Build["Vertical"])}
                elseif($IgnoreTop -eq $False){($Build["TopLeftCorner"]) + (($Build["Horizontal"]) * $PaddingMultiplier) + ($Build["TopRightCorner"])}
            $Lines[($Lines.Count)] = 
                if($MiddleBorder -eq $True){($Build["MiddleLeft"]) + (($Build["Horizontal"]) * $PaddingMultiplier) + ($Build["MiddleRight"])}
                elseif($MiddleBorder -eq $False){($Build["BottomLeftCorner"]) + (($Build["Horizontal"]) * $PaddingMultiplier) + ($Build["BottomRightCorner"])}
            # Fill the Lines Array
            $Start = ($OuterBuildLines + 1)
            $End = (($Lines.Count) - $OuterBuildLines)
            Foreach($Num in $Start..$End){
                $Segment = $InputObject[$Num-$Start]
                #Determine Segment Padding Needed
                $LeftPaddingRequired = 
                    if($Justification -eq "Center"){
                        [Math]::floor((($EnforcedMaxLength / 2) - ($Build["Vertical"]).Length) - ($Segment.Length / 2))
                    }
                    elseif($Justification -eq "Left"){
                        $MinimumPaddingLength
                    }
                    elseif($Justification -eq "Right"){
                        ($EnforcedMaxLength - $Segment.Length - (($Build["Vertical"]).Length + ($Build["Vertical"]).Length)) - $RightPaddingRequired
                    }
                    elseif($Justification -eq "None"){
                        if($Segment.Length -lt $MaxLineWidth){
                            [Math]::ceiling(($MaxLineWidth - $Segment.Length) / 2)
                        }
                        else{1}
                    }
                $RightPaddingRequired = 
                    if($Justification -eq "Center"){
                        [Math]::ceiling((($EnforcedMaxLength / 2) - ($Build["Vertical"]).Length) - ($Segment.Length / 2))
                    }
                    elseif($Justification -eq "Left"){
                        ($EnforcedMaxLength - $Segment.Length - (($Build["Vertical"]).Length + ($Build["Vertical"]).Length)) - $LeftPaddingRequired
                    }
                    elseif($Justification -eq "Right"){
                        $MinimumPaddingLength
                    }
                    elseif($Justification -eq "None"){
                        if($Segment.Length -lt $MaxLineWidth){
                            [Math]::floor(($MaxLineWidth - $Segment.Length) / 2)
                        }
                        else{
                            1
                        }
                    }
                $RightPadding = (("$($Padding)") * ($RightPaddingRequired)) + ($Build["Vertical"])
                $LeftPadding = ($Build["Vertical"]) + (("$($Padding)") * ($LeftPaddingRequired))
                $AssembledSegment = $LeftPadding + $Segment + $RightPadding
                $Lines[$Num] += $AssembledSegment
            }
        } # End If Boxed
    } # End Begin
    Process {
        #Return the Output
        $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
            $_
        }
    }
} # End Function
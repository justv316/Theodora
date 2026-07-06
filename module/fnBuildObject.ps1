function fnBuildObject{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Array]$InputObject,
        [String]$BuildFormatting,
        [String]$BorderType
    )
    begin{
        if(-not(Get-Variable -ErrorAction SilentlyContinue -Scope Global -name BorderCharacters)){
            $Global:BorderCharacters = @()
        }
        if($Null -eq $Characters){
            fnXML "Characters"
        }
        if($Null -eq $Boxes){
            fnXML "Boxes"
        }
     #Parse Build Formatting
        $BuildParamArr = $BuildFormatting -Split ' '
        $BuildParam = ConvertTo-Params $BuildParamArr -schema @{
            ObjectType = [String],''
            Justification = [String], 'None'
            IgnoreTop = [String], 'false'
            MiddleBorder = [String], 'false'
            Padding = [String],''
        }
        $BuildParamHash = @{}
        $BuildParamKeys = $BuildParam.Keys
        Foreach($Key in $BuildParamKeys){
            $BuildParamHash["$Key"] = $BuildParam[$Key].Value
        }
        $ObjectType = If($Null -ne $BuildParamHash["ObjectType"]){$BuildParamHash["ObjectType"]}elseif($Null -eq $BuildParamHash["ObjectType"]){throw "ObjectType is Required."}
        $Justification = if($Null -ne $BuildParamHash["Justification"]){$BuildParamHash["Justification"]}else{"None"}
        $IgnoreTop = If($BuildParamHash["IgnoreTop"] -eq "True"){$True}else{$False}
        $MiddleBorder = If($BuildParamHash["MiddleBorder"] -eq "True"){$True}else{$False}
        $Padding = if($BuildParamHash["Padding"]){$BuildParamHash["Padding"]}else{" "}
    #End Build Formatting
        if($ObjectType -eq "Boxed"){
            $BorderTypes = @("Vertical", "Horizontal", "TopLeftCorner", "BottomLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner", "MiddleLeft", "MiddleRight", "CenterJunction")
            $BorderTypes | Foreach-Object{
                $Global:BorderCharacters += $Boxes[$($BorderType)].$($_)
            }
            $BorderLineCount = ($Boxes[$($BorderType)]).Vertical.Length * 2
            $OuterBuildLines = ($Boxes[$($BorderType)]).Vertical.Length
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
                if($IgnoreTop -eq $True){}
                elseif($IgnoreTop -eq $False){(($Boxes[$($BorderType)])["TopLeftCorner"]) + ((($Boxes[$($BorderType)])["Horizontal"]) * $PaddingMultiplier) + (($Boxes[$($BorderType)])["TopRightCorner"])}
            $Lines[($Lines.Count)] = 
                if($MiddleBorder -eq $True){(($Boxes[$($BorderType)])["MiddleLeft"]) + ((($Boxes[$($BorderType)])["Horizontal"]) * $PaddingMultiplier) + (($Boxes[$($BorderType)])["MiddleRight"])}
                elseif($MiddleBorder -eq $False){(($Boxes[$($BorderType)])["BottomLeftCorner"]) + ((($Boxes[$($BorderType)])["Horizontal"]) * $PaddingMultiplier) + (($Boxes[$($BorderType)])["BottomRightCorner"])}
            # Fill the Lines Array
            $Start = ($OuterBuildLines + 1)
            $End = (($Lines.Count) - $OuterBuildLines)
            Foreach($Num in $Start..$End){
                $Segment = $InputObject[$Num-$Start]
                #Determine Segment Padding Needed
                $LeftPaddingRequired = 
                    if($Justification -eq "Center"){
                        [Math]::floor((($EnforcedMaxLength / 2) - (($Boxes[$($BorderType)])["Vertical"]).Length) - ($Segment.Length / 2))
                    }
                    elseif($Justification -eq "Left"){
                        $MinimumPaddingLength
                    }
                    elseif($Justification -eq "Right"){
                        ($EnforcedMaxLength - $Segment.Length - ((($Boxes[$($BorderType)])["Vertical"]).Length + (($Boxes[$($BorderType)])["Vertical"]).Length)) - $RightPaddingRequired
                    }
                    elseif($Justification -eq "None"){
                        if($Segment.Length -lt $MaxLineWidth){
                            [Math]::ceiling(($MaxLineWidth - $Segment.Length) / 2) + 1
                        }
                        else{1}
                    }
                $RightPaddingRequired = 
                    if($Justification -eq "Center"){
                        [Math]::ceiling((($EnforcedMaxLength / 2) - (($Boxes[$($BorderType)])["Vertical"]).Length) - ($Segment.Length / 2))
                    }
                    elseif($Justification -eq "Left"){
                        ($EnforcedMaxLength - $Segment.Length - ((($Boxes[$($BorderType)])["Vertical"]).Length + (($Boxes[$($BorderType)])["Vertical"]).Length)) - $LeftPaddingRequired
                    }
                    elseif($Justification -eq "Right"){
                        $MinimumPaddingLength
                    }
                    elseif($Justification -eq "None"){
                        if($Segment.Length -lt $MaxLineWidth){
                            [Math]::floor(($MaxLineWidth - $Segment.Length) / 2) + 1
                        }
                        else{
                            1
                        }
                    }
                if($OuterBuildLines -eq 1 -and $Justification -ne "None"){
                    $RightPaddingRequired = [Math]::ceiling($RightPaddingRequired + 1)
                }
                $LeftBorder = (($Boxes[$($BorderType)])["Vertical"])
                $LeftPadding = ("$($Padding)" * ($LeftPaddingRequired))
                $RightPadding = ("$($Padding)" * ($RightPaddingRequired))
                $RightBorder = (($Boxes[$($BorderType)])["Vertical"])
                $AssembledSegment = $LeftBorder + $LeftPadding + $Segment + $RightPadding + $RightBorder
                $Lines[$Num] += $AssembledSegment
            }
        } # End If Boxed
    }
    process{
        if($ObjectType -eq "Boxed"){
            $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
                $_
            }
        }
    }
}
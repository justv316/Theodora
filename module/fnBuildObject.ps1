function fnBuildObject{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Array]$InputObject,
        [String]$BuildFormatting,
        [String]$GridFormatting,
        [String]$BorderType,
        [int] $EnforcedMaxLength = 160,
        [int] $MinimumPaddingLength = 4
    )
    begin{
        # Build Reference Hashes
        if(-not(Get-Variable -ErrorAction SilentlyContinue -Scope Global -name BorderCharacters)){
            $Global:BorderCharacters = @()
        }
        if($Null -eq $Boxes){
            fnXML "Boxes"
        }
        # Argument Parsing
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
        # End Argument Parsing
        if($ObjectType -eq "Grid"){
            $GridParamArr = $GridFormatting -Split ' '
            $GridParam = ConvertTo-Params $GridParamArr -schema @{
                GridRange = [int[]],@()
                GridBorder = [String],''
                GridJustification = [String],''
                Headers = [String[]],@()
                HeadersFont = [String[]],@()
                HeadersBorder = [String[]],@()
                HeadersObjectBorder = [String[]],@()
                HeadersJustification = [String[]],@()
                HeadersIgnoreTop = [String[]],@()
                HeadersMiddleBorder = [String[]],@()
                Buttons = [String[]],@()
                ButtonsFont = [String[]],@()
                ButtonsBorder = [String[]],@()
                ButtonsObjectBorder = [String[]],@()
                ButtonsJustification = [String[]],@()
            }
            $GridParamHash = @{}
            $GridParamKeys = $GridParam.Keys
            Foreach($Key in $GridParamKeys){
                $GridParamHash["$Key"] = $GridParam[$Key].Value
            }
            $GridRange = if($Null -ne $GridParamHash["GridRange"]){$GridParamHash["GridRange"]}elseif($Null -eq $GridParamHash["GridRange"]){Throw "A grid range is required when Grid is specified"}
            $GridBorder = if($Null -ne $GridParamHash["GridBorder"]){$GridParamHash["GridBorder"]}
            $GridJustification = if($Null -ne $GridParamHash["GridJustification"]){$GridParamHash["GridJustification"]}
            $Headers = if($Null -ne $GridParamHash["Headers"]){$GridParamHash["Headers"]}else{$False}
            $Buttons = if($Null -ne $GridParamHash["Buttons"]){$GridParamHash["Buttons"]}else{$False}
            $ButtonsFont = if($Null -ne $GridParamHash["ButtonsFont"]){$GridParamHash["ButtonsFont"]}
            $ButtonsBorder = if($Null -ne $GridParamHash["ButtonsBorder"]){$GridParamHash["ButtonsBorder"]}
            $ButtonsObjectBorder = if($Null -ne $GridParamHash["ButtonsObjectBorder"]){$GridParamHash["ButtonsObjectBorder"]}
            $ButtonsJustification = if($Null -ne $GridParamHash["ButtonsJustification"]){$GridParamHash["ButtonsJustification"]}
            $HeadersFont = if($Null -ne $GridParamHash["HeadersFont"]){$GridParamHash["HeadersFont"]}
            $HeadersBorder = if($Null -ne $GridParamHash["HeadersBorder"]){$GridParamHash["HeadersBorder"]}
            $HeadersObjectBorder = if($Null -ne $GridParamHash["HeadersObjectBorder"]){$GridParamHash["HeadersObjectBorder"]}
            $HeadersJustification = if($Null -ne $GridParamHash["HeadersJustification"]){$GridParamHash["HeadersJustification"]}
            $HeadersIgnoreTop = if($Null -ne $GridParamHash["HeadersIgnoreTop"]){$GridParamHash["HeadersIgnoreTop"]}
            $HeadersMiddleBorder = if($Null -ne $GridParamHash["HeadersMiddleBorder"]){$GridParamHash["HeadersMiddleBorder"]}
            $HeadersArray = @()
            foreach($num in 0..($Headers.Count - 1)){
                $Header = [PSCustomObject]@{
                    Header = $Headers[$num].Replace('_', ' ')
                    Font = $HeadersFont[$num]
                    Border = $HeadersBorder[$num]
                    ObjectBorder = $HeadersObjectBorder[$num]
                    Justification = $HeadersJustification[$num]
                    IgnoreTop = $HeadersIgnoreTop[$Num]
                    MiddleBorder = $HeadersMiddleBorder[$num]
                }
                $HeadersArray += $Header
            }
            $BuiltObjects = @()
            $HeadersArray | Foreach-Object {
                $SubObject = 
                    if($_.Font -ne "None"){
                        $ASCII = fnGetAscii -InputString $_.Header -Font $_.Font -BorderType $_.ObjectBorder -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                        fnBuildObject -InputObject $ASCII -BorderType $_.ObjectBorder -BuildFormatting "--ObjectType=Boxed" -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                    }
                    else{
                        fnBuildObject -InputObject $_.Header -BorderType $_.ObjectBorder -BuildFormatting "--ObjectType=Boxed" -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                    }
                $BuiltHeader = fnBuildObject -InputObject $SubObject -BorderType $_.Border -BuildFormatting "--ObjectType=Boxed --Justification=$($_.Justification) --MiddleBorder=$($_.MiddleBorder) --IgnoreTop=$($_.IgnoreTop)" -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                $BuiltObjects += $BuiltHeader
            }
            $ButtonsArray = @()
            foreach($num in 0..($Buttons.Count - 1)){
                $Button = [PSCustomObject]@{
                    Index = $Num -as [Int]
                    Button = $Buttons[$num].Replace('_', ' ')
                    Font = $ButtonsFont[$num]
                    Border = $ButtonsBorder[$num]
                    ObjectBorder = $ButtonsObjectBorder[$num]
                    Justification = $ButtonsJustification[$num]
                }
                $ButtonsArray += $Button
            }
            #Put Button 1 and 2 on the same lines
            $RowsReq = [Math]::Ceiling($Buttons.Count / $GridRange[1])
            $Rows = @{}
            $StartIndex = 0
            $EndIndex = ($RowsReq - 1)
            foreach($Num in 0..($RowsReq - 1)){
                $Rows[$($Num)] = [PSCustomObject]@{
                    Index = $num -as [Int]
                    Range = @()
                    Contents = @()
                    Buttons = [System.Collections.SortedList]::new()
                }
                $Rows[$($Num)].Range = $StartIndex..$EndIndex
                $StartIndex = $EndIndex + 1
                $EndIndex = $EndIndex + $RowsReq
            }
            $RowInd = 0
            while($RowInd -le ($Rows.Count - 1)){
                $ButtonsArray | Foreach-Object{
                    $Button = $_
                    if($Rows[$RowInd].Range -Contains $Button.Index){
                        $Rows[$RowInd].Contents += $Button
                    }
                }
                $RowInd++
            }
            # Build Rows and add to built object
            Foreach($RowNum in 0..($Rows.Count - 1)){
                $ButtonsCount = $Rows[$RowNum].Contents.Count
                $ButtonNumber = 1
                $Rows[$RowNum].Contents | Foreach-Object {
                    $Button = $_
                    $SubObject = 
                        if($Button.Font -ne "None"){
                            $ASCII = fnGetAscii -InputString $Button.Button -Font $Button.Font -BorderType $Button.ObjectBorder -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                            fnBuildObject -InputObject $ASCII -BorderType $Button.ObjectBorder -BuildFormatting "--ObjectType=Boxed" -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                        }
                        else{
                            fnBuildObject -InputObject $Button.Button -BorderType $Button.ObjectBorder -BuildFormatting "--ObjectType=Boxed" -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
                        }
                    $LineArr = $SubObject.Split("`n")
                    foreach($num in 1..$LineArr.Count){
                        $Rows[$RowNum].Buttons[$($num)] += $LineArr[$num-1]
                        if($Null -ne $GridBorder -and $ButtonNumber -ne $ButtonsCount){
                            $Rows[$RowNum].Buttons[$($num)] += " "+" "+" "
                        }
                    }
                        $ButtonNumber++
                }
                $EnumeratedButtons = ($Rows[$RowNum].Buttons).GetEnumerator() | Select-Object -ExpandProperty Value
                $ConstructedGridRow = fnBuildObject -InputObject $EnumeratedButtons -BorderType $GridBorder -BuildFormatting "--ObjectType=Boxed --Justification=$($GridJustification) --IgnoreTop=True --MiddleBorder=True" 
                $BuiltObjects += $ConstructedGridRow
            }
            if($RowNum -eq ($Rows.Count - 1)){
                $Build = ($Boxes[$($GridBorder)])
                $OuterBuildLines = $Build.Vertical.Length
                $PaddingMultiplier = 
                    if($Justification -eq "None"){$MaxLineWidth + $BorderLineCount}
                    else{$EnforcedMaxLength - $OuterBuildLines}
                $BuiltObjects += (($Build["BottomLeftCorner"]) + (($Build["Horizontal"]) * $PaddingMultiplier) + ($Build["BottomRightCorner"]))
            }
        }
        if($ObjectType -eq "Boxed"){
            $BorderTypes = @("Vertical", "Horizontal", "TopLeftCorner", "BottomLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner", "MiddleLeft", "MiddleRight", "CenterJunction")
            $BorderTypes | Foreach-Object{
                $BorderCharacters += $Boxes[$($BorderType)]["$($_)"]
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
                            [Math]::ceiling(($MaxLineWidth - $Segment.Length) / 2)
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
                            [Math]::floor(($MaxLineWidth - $Segment.Length) / 2)
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
    } # End Begin
    Process {
        #Return the Output
        if($ObjectType -eq "Boxed"){
            $Lines.GetEnumerator() | Sort-Object -Property Name | Select-Object -ExpandProperty Value | ForEach-Object {
                $_
            }
        }
        elseif($ObjectType -eq "Grid"){
            $BuiltObjects
        }
    }
} # End Function
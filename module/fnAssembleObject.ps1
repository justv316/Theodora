function fnAssembleObject{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Array]$InputObject,
        [String]$BuildFormatting,
        [String]$GridFormatting,
        [String]$ColorFormatting,
        [String]$ManualFormatting,
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
        if($BuildFormatting -ne '' -and $Null -ne $BuildFormatting){
            $BuildParamArr = $BuildFormatting -Split ' '
            $BuildParam = ConvertTo-Params $BuildParamArr -schema @{
                ObjectType = [String],''
                Justification = [String], 'None'
                IgnoreTop = [String], 'false'
                MiddleBorder = [String], 'false'
                Padding = [String],''
                EnforcedMaxLength = [Int],160
                MinimumPaddingLength = [Int],4
            }
            $BuildParamHash = @{}
            $BuildParamKeys = $BuildParam.Keys
            Foreach($Key in $BuildParamKeys){
                $BuildParamHash["$Key"] = $BuildParam[$Key].Value
            }
            #$ObjectType = If($Null -ne $BuildParamHash["ObjectType"]){$BuildParamHash["ObjectType"]}elseif($Null -eq $BuildParamHash["ObjectType"]){throw "ObjectType is Required."}
            $Justification = if($Null -ne $BuildParamHash["Justification"]){$BuildParamHash["Justification"]}else{"None"}
            $IgnoreTop = If($BuildParamHash["IgnoreTop"] -eq "True"){$True}else{$False}
            $MiddleBorder = If($BuildParamHash["MiddleBorder"] -eq "True"){$True}else{$False}
            $Padding = if($BuildParamHash["Padding"]){$BuildParamHash["Padding"]}else{" "}
            $Script:EnforcedMaxLength = if($Null -ne $BuildParamHash["EnforcedMaxLength"]){$BuildParamHash["EnforcedMaxLength"]}else{160}
            $Script:MinimumPaddingLength = if($Null -ne $BuildParamHash["MinimumPaddingLength"]){$BuildParamHash["MinimumPaddingLength"]}else{4}
            $BuiltObjects = @()
        }
        else{
            $BuiltObjects = $InputObject
        }#End Build Formatting
    # Parse Color Formatting
        $Colors = @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow',
            'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')
        $ForegroundColor = "White"
        $BackgroundColor = "Black"
        $TextForegroundColor = "White"
        $TextBackgroundColor = "Black"
        $BorderForegroundColor = "White"
        $BorderBackgroundColor = "Black"
        if($ColorFormatting -ne '' -and $Null -ne $ColorFormatting){
            $ColorFormattingArr = $ColorFormatting -Split ' '
            $ColorParams = ConvertTo-Params $ColorFormattingArr -schema @{
                ForegroundColor = [String], 'White'
                BackgroundColor = [String], 'Black'
                TextForegroundColor = [String], 'White'
                TextBackgroundColor = [String], 'Black'
                BorderForegroundColor = [String], 'White'
                BorderBackgroundColor = [String], 'Black'
                IgnoreBorderPadding = [Switch]
                IgnoreTextPadding = [Switch]
            }
            $ColorParamsHash = @{}
            $ColorParamKeys = $ColorParams.Keys
            Foreach($Key in $ColorParamKeys){
                $ColorParamsHash["$Key"] = $ColorParams[$Key].Value
            }
        # Define Colors
            $IgnoreBorderPadding = if($Null -ne $ColorParamsHash["IgnoreBorderPadding"]){$False}else{$True}
            $IgnoreTextPadding = if($Null -ne $ColorParamsHash["IgnoreTextPadding"]){$False}else{$True}
            $ForegroundColor = if($Null -ne $ColorParamsHash["ForegroundColor"]){$ColorParamsHash["ForegroundColor"]}else{"White"}
            $BackgroundColor = if($Null -ne $ColorParamsHash["BackgroundColor"]){$ColorParamsHash["BackgroundColor"]}else{"Black"}
            $BorderColors = @{
                "BorderForegroundColor" = $ColorParamsHash["BorderForegroundColor"]
                "BorderBackgroundColor" = $ColorParamsHash["BorderBackgroundColor"]
            }
            $TextColors = @{
                "TextForegroundColor" = $ColorParamsHash["TextForegroundColor"]
                "TextBackgroundColor" = $ColorParamsHash["TextBackgroundColor"]}
            $TextForegroundColor = if($Null -ne $TextColors["TextForegroundColor"]){$TextColors["TextForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $TextBackgroundColor = if($Null -ne $TextColors["TextBackgroundColor"]){$TextColors["TextBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
            $BorderForegroundColor = if($Null -ne $BorderColors["BorderForegroundColor"]){$BorderColors["BorderForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $BorderBackgroundColor = if($Null -ne $BorderColors["BorderBackgroundColor"]){$BorderColors["BorderBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
        } #End ColorFormatting Parsing
    # Parse Grid Formatting
        if($GridFormatting -ne '' -and $Null -ne $GridFormatting){
            $GridParamArr = $GridFormatting -Split ' '
            $GridParam = ConvertTo-Params $GridParamArr -schema @{
                GridRows = [int],1
                GridColumns = [Int],1
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
            $GridRows = if($Null -ne $GridParamHash["GridRows"]){$GridParamHash["GridRows"]}else{"ToFit"}
            $GridColumns = if($Null -ne $GridParamHash["GridColumns"]){$GridParamHash["GridColumns"]}else{1}
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
        } #End Grid Formatting
    # Parse ManualFormatting
        if($ManualFormatting -ne '' -and $Null -ne $ManualFormatting){
            $ManualFormattingArr = $ManualFormatting -Split ' '
            $ManualParams = ConvertTo-Params $ManualFormattingArr -schema @{
                Index = [int[]],@()
                IndexRange = [String[]],@()
                Line = [int[]],@()
                LineRange = [String[]],@()
                ForegroundColor = [String[]],@()
                BackgroundColor = [String[]],@()
                Replace = [String[]],@()
            }
            $ManualParamsHash = @{}
            $ManualParamKeys = $ManualParams.Keys
            Foreach($Key in $ManualParamKeys){
                $ManualParamsHash["$Key"] = $ManualParams[$Key].Value
            }
            if(($Null -eq $ManualParamsHash["LineRange"] -and ($Null -ne $ManualParamsHash["IndexRange"] -or $Null -ne $ManualParamsHash["Index"])) -or ($Null -eq $ManualParamsHash["IndexRange"] -and ($Null -ne $ManualParamsHash["LineRange"] -or $Null -ne $ManualParamsHash["Line"]))){Throw "Both a Line Range and an Index Range are required"}
            if($ManualParamsHash["LineRange"].Count -ne $ManualParamsHash["IndexRange"].Count){Throw "The Line Range must be the same length as the Index Range"}
            $SpecifiedTerms = if($Null -ne $ManualParamsHash["LineRange"]){$ManualParamsHash["LineRange"].Count}elseif($Null -ne $ManualParamsHash["Line"]){$ManualParamsHash["Line"].Count}
            $LineRange = if($Null -ne $ManualParamsHash["LineRange"]){$ManualParamsHash["LineRange"]}elseif($Null -ne $ManualParamsHash["Line"]){$ManualParamsHash["Line"]}
            $IndexArr = if($Null -ne $ManualParamsHash["IndexRange"]){$ManualParamsHash["IndexRange"]}elseif($Null -ne $ManualParamsHash["Index"]){$ManualParamsHash["Index"]}
            if($Null -ne $ManualParamsHash["ForegroundColor"]){$ForegroundColorArr = $ManualParamsHash["ForegroundColor"]}
            if($Null -ne $ManualParamsHash["BackgroundColor"]){$BackgroundColorArr = $ManualParamsHash["BackgroundColor"]}
            if($Null -ne $ManualParamsHash["Replace"]){$ReplaceArr = $ManualParamsHash["Replace"]}
        } #End Manual Formatting
    } #End Begin
    Process{
    #Build Objects
        if($Headers -and $Headers.Count -ge 1){
            $HeadersArray = @()
            if($Headers -and $Headers.Count -eq 1){
                $Header = [PSCustomObject]@{
                    Header = $Headers.Replace('_', ' ')
                    Font = $HeadersFont
                    Border = $HeadersBorder
                    ObjectBorder = $HeadersObjectBorder
                    Justification = $HeadersJustification
                    IgnoreTop = $HeadersIgnoreTop
                    MiddleBorder = $HeadersMiddleBorder
                }
                $HeadersArray += $Header
            }
            elseif($Headers -and $Headers.Count -gt 1){
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
            }
            $HeadersArray | Foreach-Object {
                $SubObject = 
                    if($_.Font -ne "None"){
                        $ASCII = fnGetAscii -InputString $_.Header -Font $_.Font -BorderType $_.ObjectBorder
                        fnBuildObject -InputObject $ASCII -BorderType $_.ObjectBorder -BuildFormatting "--ObjectType=Boxed"
                    }
                    else{
                        fnBuildObject -InputObject $_.Header -BorderType $_.ObjectBorder -BuildFormatting "--ObjectType=Boxed"
                    }
                $BuiltHeader = fnBuildObject -InputObject $SubObject -BorderType $_.Border -BuildFormatting "--ObjectType=Boxed --Justification=$($_.Justification) --MiddleBorder=$($_.MiddleBorder) --IgnoreTop=$($_.IgnoreTop)"
                $BuiltObjects += $BuiltHeader
            }
        } #End Headers
        if($Buttons -and $Buttons.Count -ge 1){
            $ButtonsArray = @()
            if($Buttons.Count -eq 1){
                $Button = [PSCustomObject]@{
                    Index = 1 -as [Int]
                    Button = $Buttons = $Buttons -Replace "_", " " -replace "/nl", "`n"
                    Font = $ButtonsFont
                    Border = $ButtonsBorder
                    ObjectBorder = $ButtonsObjectBorder
                    Justification = $ButtonsJustification
                }
                $ButtonsArray += $Button
            }
            else{
                foreach($num in 0..($Buttons.Count - 1)){
                    $Button = [PSCustomObject]@{
                        Index = $Num -as [Int]
                        Button = $Buttons[$num] = $Buttons[$num] -Replace "_", " " -replace "/nl", "`n"
                        Font = $ButtonsFont[$num]
                        Border = $ButtonsBorder[$num]
                        ObjectBorder = $ButtonsObjectBorder[$num]
                        Justification = $ButtonsJustification[$num]
                    }
                    $ButtonsArray += $Button
                }
            }
            #Put Button 1 and 2 on the same lines
            if($GridRows -eq "ToFit"){
                $RowsReq = [Math]::Ceiling($Buttons.Count / $GridColumns)
            }
            $Rows = @{}
            $StartIndex = 0
            $EndIndex = $GridColumns - 1
            foreach($Num in 0..($RowsReq - 1)){
                $Rows[$($Num)] = [PSCustomObject]@{
                    Index = $num -as [Int]
                    Range = @()
                    Contents = @()
                    Buttons = [System.Collections.SortedList]::new()
                }
                $Rows[$($Num)].Range = $StartIndex..$EndIndex
                $StartIndex = $StartIndex + $GridColumns
                $EndIndex = $EndIndex + $GridColumns
            }
            $RowInd = 0
            while($RowInd -le ($Rows.Count - 1)){
                if($ButtonsArray.Count -gt 1){
                    $ButtonsArray | Foreach-Object{
                        $Button = $_
                        if($Rows[$RowInd].Range -Contains $Button.Index){
                            $Rows[$RowInd].Contents += $Button
                        }
                    }
                }
                else{
                    $Rows[$RowInd].Contents += $ButtonsArray
                }
                $RowInd++
            }
            Foreach($RowNum in 0..($Rows.Count - 1)){
            $ButtonsCount = $Rows[$RowNum].Contents.Count
            $ButtonNumber = 1
            $MaxLineCount = 0
            $Rows[$RowNum].Contents | Foreach-Object {
                $Button = $_
                $SubObject = 
                    if($Button.Font -ne "None"){
                        $ASCII = fnGetAscii -InputString $Button.Button -Font $Button.Font -BorderType $Button.ObjectBorder
                        fnBuildObject -InputObject $ASCII -BorderType $Button.ObjectBorder -BuildFormatting "--ObjectType=Boxed"
                    }
                    else{
                        fnBuildObject -InputObject $Button.Button -BorderType $Button.ObjectBorder -BuildFormatting "--ObjectType=Boxed"
                    }
                if($Null -ne $Button.Border){
                    $BoxedButton = fnBuildObject -InputObject $SubObject -BorderType $Button.Border -BuildFormatting "--ObjectType=Boxed"
                    $LineArr = $BoxedButton.Split("`n")
                    $LineArrList = New-Object System.Collections.ArrayList(,$LineArr)
                    if($LineArrList.Count -gt $MaxLineCount){$MaxLineCount = $LineArrList.Count}
                }
                else{
                    $LineArr = $SubObject.Split("`n")
                    $LineArrList = New-Object System.Collections.ArrayList(,$LineArr)
                    if($LineArrList.Count -gt $MaxLineCount){$MaxLineCount = $LineArrList.Count}
                }
                if($LineArrList.Count -lt $MaxLineCount){
                    foreach($num in 0..(($MaxLineCount - $LineArrList.Count) - 1)){
                        $Padding = ' ' * ($LineArrList[$num].Length) -as [String]
                        if($Num % 2 -eq 0){
                            $LineArrList.Insert($num,$Padding)
                        }
                        else{
                            $LineArrList.Add($Padding)
                        }
                    }
                }
                foreach($num in 1..$LineArrList.Count){
                    $Rows[$RowNum].Buttons[$($num)] += $LineArrList[$num-1]
                    if($Null -ne $GridBorder -and $ButtonNumber -ne $ButtonsCount){
                        $Pad = " " * $MinimumPaddingLength
                        $Rows[$RowNum].Buttons[$($num)] += "$Pad"+"$($Boxes[$($GridBorder)]["Vertical"])"+"$Pad"
                    }
                }
                $ButtonNumber++
            }
            $EnumeratedButtons = ($Rows[$RowNum].Buttons).GetEnumerator() | Select-Object -ExpandProperty Value
            if($Headers -ne $False -or $RowNum -gt 0){
                $ConstructedGridRow = fnBuildObject -InputObject $EnumeratedButtons -BorderType $GridBorder -BuildFormatting "--ObjectType=Boxed --Justification=$($GridJustification) --IgnoreTop=True --MiddleBorder=True"
            }
            elseif($Headers -eq $False){
                $ConstructedGridRow = fnBuildObject -InputObject $EnumeratedButtons -BorderType $GridBorder -BuildFormatting "--ObjectType=Boxed --Justification=$($GridJustification) --MiddleBorder=True"
            }
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
        } #End Buttons
    # End Build Objects
    # Create a Character Grid
        $LineCount = $BuiltObjects.Count
        $CharacterGrid = [System.Collections.SortedList]::new()
        foreach($LineNumber in 1..($LineCount)){
            $CharacterGrid[$LineNumber] = @()
            $LineArray = [Char[]]$BuiltObjects[$LineNumber-1]
            $CharNumber = 1
            foreach($Char in $LineArray){
                $CharacterType = 
                    if($Char -eq ' '){"Padding"}
                    elseif($BorderCharacters -contains $Char){"Border"}
                    else{"Character"}
                if($CharacterType -eq "Border"){
                    if($BorderForegroundColor -eq 'Rainbow' -or $ForegroundColor -eq 'Rainbow'){
                        $ForegroundColor = $Colors[(Get-Random -Min 0 -Max 15)]
                    }
                    else{
                        $ForegroundColor = $BorderForegroundColor
                    }
                    if($BorderBackgroundColor -eq 'Rainbow' -or $BackgroundColor -eq 'Rainbow'){
                        $BackgroundColor = $Colors[(Get-Random -Min 0 -Max 15)]
                    }
                    else{
                        $BackgroundColor = $BorderBackgroundColor
                    }
                }
                elseif($CharacterType -eq "Character"){
                    if($TextForegroundColor -eq 'Rainbow' -or $ForegroundColor -eq 'Rainbow'){
                        $ForegroundColor = $Colors[(Get-Random -Min 0 -Max 15)]
                    }
                    else{
                        $ForegroundColor = $TextForegroundColor
                    }
                    if($BorderBackgroundColor -eq 'Rainbow' -or $BackgroundColor -eq 'Rainbow'){
                        $BackgroundColor = $Colors[(Get-Random -Min 0 -Max 15)]
                    }
                    else{
                        $BackgroundColor = $TextBackgroundColor
                    }
                }
                $Chars = [PSCustomObject] @{
                    'Index' = $CharNumber
                    'Line' = $LineNumber
                    'Character' = "$Char"
                    'ForegroundColor' = "$ForegroundColor"
                    'BackgroundColor' = "$BackgroundColor"
                    'Type' = "$CharacterType"
                }
                $CharNumber++
                $CharacterGrid[$LineNumber] += $Chars
            }
        }
        foreach($LineNumber in 1..($LineCount)){
            foreach($Character in $CharacterGrid[$LineNumber]){
                if($Character.Type -eq "Padding"){
                    if($CharacterGrid[$LineNumber][$Character.Index-1].Type -eq "Character" -or $CharacterGrid[$LineNumber][$Character.Index+1].Type -eq "Character"){
                        $Character.Type = "Character Padding"
                        if($IgnoreTextPadding -eq $True){
                            $Character.ForegroundColor = "White"
                            $Character.BackgroundColor = "Black"
                        }
                        else{
                            $Character.ForegroundColor = $TextForegroundColor
                            $Character.BackgroundColor = $TextBackgroundColor
                        }
                    }
                    elseif($CharacterGrid[$LineNumber][$Character.Index-1].Type -eq "Border" -or $CharacterGrid[$LineNumber][$Character.Index+1].Type -eq "Border" -or $CharacterGrid[$LineNumber][$Character.Index-1].Type -eq "Padding" -or $CharacterGrid[$LineNumber][$Character.Index+1].Type -eq "Padding"){
                        $Character.Type = "Border Padding"
                        if($IgnoreBorderPadding -eq $True){
                            $Character.ForegroundColor = "White"
                            $Character.BackgroundColor = "Black"
                        }
                        else{
                            $Character.ForegroundColor = $BorderForegroundColor
                            $Character.BackgroundColor = $BorderBackgroundColor
                        }
                    }
                }
                # If Horizontal is above or below a Vertical, replace with appropriate junction
                if($CharacterSets["Horizontal"] -contains $Character.Character){
                    $BorderPos = [array]::indexof($CharacterSets["Horizontal"],$Character.Character)
                    if($LineNumber -ne $LineCount){
                        $AboveCharacter = $CharacterGrid[$LineNumber + 1][$Character.Index - 1]
                    }
                    if($LineNumber -ne 1){
                        $BelowCharacter = $CharacterGrid[$LineNumber - 1][$Character.Index - 1]
                    }
                    if($CharacterSets["Vertical"] -contains $AboveCharacter.Character -and $CharacterSets["Vertical"] -contains $BelowCharacter.Character){
                        $Character.Character = $CharacterSets["CenterJunction"][$BorderPos]
                    }
                    if($CharacterSets["Vertical"] -contains $AboveCharacter.Character -and -not ($CharacterSets["Vertical"] -contains $BelowCharacter.Character)){
                        $Character.Character = $CharacterSets["MiddleTop"][$BorderPos]
                    }
                    if($CharacterSets["Vertical"] -contains $BelowCharacter.Character -and -not ($CharacterSets["Vertical"] -contains $AboveCharacter.Character)){
                        $Character.Character = $CharacterSets["MiddleBottom"][$BorderPos]
                    }
                }
            }
        } # End Character Grid
        if($ManualFormatting -ne '' -and $Null -ne $ManualFormatting){
            $TermHash = @{}
            for($n = 1; $n -le $SpecifiedTerms; $n++){
                $TermHash["$($n)"] = [PSCustomObject]@{
                    LineRange = ($LineRange[$n-1] -Split ',')[0]..($LineRange[$n-1] -Split ',')[1]
                    IndexRange = ($IndexArr[$n-1] -Split ',')[0]..($IndexArr[$n-1] -Split ',')[1]
                    ForegroundColor = if($Null -ne $ForegroundColorArr){$ForegroundColorArr[$n-1]}
                    BackgroundColor = if($Null -ne $BackgroundColorArr){$BackgroundColorArr[$n-1]}
                    Replace = if($Null -ne $ReplaceArr){($LineArr[$n-1] -Split ',')[0]}
                    ReplaceWith = if($Null -ne $ReplaceArr){($LineArr[$n-1] -Split ',')[1]}
                }
            }
            # Modify the Character Grid with the Parameters
            for($n = 1; $n -le $SpecifiedTerms; $n++){
                foreach($LineNum in $TermHash["$($n)"].LineRange){
                    foreach($Index in $TermHash["$($n)"].IndexRange){
                        if($TermHash["$($n)"].ForegroundColor -ne '' -and $Null -ne $TermHash["$($n)"].ForegroundColor){
                            ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).ForegroundColor = $TermHash["$($n)"].ForegroundColor
                        }
                        if($TermHash["$($n)"].BackgroundColor -ne '' -and $Null -ne $TermHash["$($n)"].BackgroundColor){
                            ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).BackgroundColor = $TermHash["$($n)"].BackgroundColor
                        }
                        if($TermHash["$($n)"].Replace -ne '' -and $Null -ne $TermHash["$($n)"].Replace){
                            ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).Character = ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).Character -replace $Replace,$ReplaceWith
                        }
                    }
                }
            }
        } # End Manual Formatting
    } # End Process
    end{
        $CharacterGrid
    }
}
function fnWriteObject{
    [CmdletBinding()]
    param(
        [String] $InputString,
        [String] $ManualFormatting = '',
        [String] $ColorFormatting = '',
        [String] $BuildFormatting = '',
        [String] $ObjectFormatting = '',
        [String] $GridFormatting = ''
    )
    <#
    ColorFormatting =  "
        --ForegroundColor
        --BackgroundColor
        --TextForegroundColor
        --BorderForegroundColor
        --TextBackgroundColor
        --BorderBackgroundColor" 
    ManualFormatting = "
        --Character=5
        --CharacterRange=5 10
        --Line=2
        --LineRange=1 2
        --ForegroundColor=White
        --BackgroundColor=Black
        --Replace=' ','@'
        --PaintPadding" 
    BuildFormatting (Given to fnBuildObject) = "
        --ObjectType=Boxed
        --Justification=None
        --IgnoreTop (Switch)
        --MiddleBorder (Switch)
        --Padding=' '"
    GridFormatting (Given to fnBuildObject) = "
        --GridRows=Int
        --GridColumns=int
        --GridBorder=Double
        --GridJustification=Center
        --Headers=@(String,String)
        --HeadersFont=@(Graceful,None)
        --HeadersBorder=@(Single,Double)
        --HeadersObjectBorder=@(Double,Single)
        --HeadersJustification=@(Center,Left)
        --HeadersIgnoreTop=@(False, True)
        --HeadersMiddleBorder=@(True,True)
        --Buttons=@(String,String)
        --ButtonsFont=@(Graceful,None)
        --ButtonsBorder=@(Double,Single)
        --ButtonsObjectBorder=@(Double,Single)
        --ButtonsJustification=@(Center,Left)
    ObjectFormatting (Used Here)  = "
        --InputType=ASCII
        --ASCIIFont=Graceful
        --BorderType=Single
        --EnforcedMaxLength=160
        --MinimumPaddingLength=4"
    #>
    begin{
        # Build Reference Hashes
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Global -Name Characters)){
            fnXML "Characters"
        }
        #Parse ObjectFormatting
        $ObjectFormattingArr = $ObjectFormatting -Split ' '
        $ObjectParams = ConvertTo-Params $ObjectFormattingArr -schema @{
            InputType = [String], ''
            ASCIIFont = [String], ''
            BorderType = [String], ''
            EnforcedMaxLength = [Int],160
            MinimumPaddingLength = [Int],4
        }
        $ObjectParamsHash = @{}
        $ObjectParamsKeys = $ObjectParams.Keys
        Foreach($Key in $ObjectParamsKeys){
            $ObjectParamsHash["$Key"] = $ObjectParams[$Key].Value
        }
        $InputType = if($Null -ne $ObjectParamsHash["InputType"]){$ObjectParamsHash["InputType"]}elseif($Null -eq $BuildParamsHash["InputType"]){throw "InputType is Required."}
        $ASCIIFont = if($Null -ne $ObjectParamsHash["ASCIIFont"]){$ObjectParamsHash["ASCIIFont"]}
        $BorderType = if($Null -ne $ObjectParamsHash["BorderType"]){$ObjectParamsHash["BorderType"]}
        $Script:EnforcedMaxLength = if($Null -ne $ObjectParamsHash["EnforcedMaxLength"]){$ObjectParamsHash["EnforcedMaxLength"]}else{160}
        $Script:MinimumPaddingLength = if($Null -ne $ObjectParamsHash["MinimumPaddingLength"]){$ObjectParamsHash["MinimumPaddingLength"]}else{4}
        #End Parse ObjectFormatting
        # Parse Color Formatting and set default colors
        $Colors = @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow',
            'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')
        $bColorFormatting = if($ColorFormatting -ne '' -and $Null -ne $ColorFormatting){$True}else{$False}
        $ForegroundColor = "White"
        $BackgroundColor = "Black"
        $TextForegroundColor = "White"
        $TextBackgroundColor = "Black"
        $BorderForegroundColor = "White"
        $BorderBackgroundColor = "Black"
        if($bColorFormatting -eq $True){
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
            $IgnoreBorderPadding = if($Null -ne $ColorParamsHash["IgnoreBorderPadding"]){$True}else{$False}
            $IgnoreTextPadding = if($Null -ne $ColorParamsHash["IgnoreTextPadding"]){$True}else{$False}
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
        }
        # Build Object
        if($InputType -eq "ASCII"){
            $ASCII = fnGetAscii -InputString $InputString -Font $ASCIIFont -BorderType $BorderType
            if($BorderType -ne "Unspecified"){
                $ConstructedASCII = fnBuildObject -InputObject $ASCII -BorderType $BorderType -BuildFormatting $BuildFormatting 
            }
            $GridInput = if($ConstructedASCII -ne '' -and $Null -ne $ConstructedASCII){$ConstructedASCII}else{$ASCII}
        }
        elseif($InputType -eq "String"){
            if($BorderType -ne "Unspecified"){
                $ConstructedString = fnBuildObject -InputObject $InputString -BorderType $BorderType -BuildFormatting $BuildFormatting
            }
            $GridInput = if($ConstructedString -ne '' -and $Null -ne $ConstructedString){$ConstructedString}else{$InputString}
        }
        elseif($InputType -eq "Menu"){
            $GridInput = fnBuildObject -BuildFormatting $BuildFormatting -GridFormatting $GridFormatting
        }
        $LineCount = $GridInput.Length
        if($BorderType -ne "Unspecified" -and $Null -ne $BorderType){
            #Get the number of Borderlines - Will always be at least the first and last lines
            if($Null -eq $Boxes){
                fnXML "Boxes"
            }
            $BorderLines = @(1, $GridInput.Length)
            $BorderColumns = @(1, $GridInput[0].Length) 
            #If there are more BorderLines, we add them to the array
            if(($Boxes[$($BorderType)])["OuterBorderLines"] -gt 1){
                $BorderLines += ($Boxes[$($BorderType)])["OuterBorderLines"]
                $BorderLines += $GridInput.Length - 1
                $BorderColumns += ($Boxes[$($BorderType)])["OuterBorderLines"]
                $BorderColumns += $GridInput[0].Length - 1
            }
        }
        #Create a Character Grid
        $CharacterGrid = [System.Collections.SortedList]::new()
        foreach($LineNumber in 1..($LineCount)){
            $CharacterGrid[$LineNumber] = @()
            $LineArray = [Char[]]$GridInput[$LineNumber-1]
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
        }
        # Parse Manual Formatting
        $bManualFormatting = if($ManualFormatting -ne '' -and $Null -ne $ManualFormatting){$True}else{$False}
        if($bManualFormatting -eq $True){
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

            if($Null -ne $ManualParamsHash["LineRange"] -or $Null -ne $ManualParamsHash["Line"] -or $Null -ne $ManualParamsHash["IndexRange"] -or $Null -ne $ManualParamsHash["Index"]){
                $SpecifiedTerms = if($Null -ne $ManualParamsHash["LineRange"]){$ManualParamsHash["LineRange"].Count}elseif($Null -ne $ManualParamsHash["Line"]){$ManualParamsHash["Line"].Count}
                $LineArr = if($Null -ne $ManualParamsHash["LineRange"]){$ManualParamsHash["LineRange"]}elseif($Null -ne $ManualParamsHash["Line"]){$ManualParamsHash["Line"]}
                $IndexArr = if($Null -ne $ManualParamsHash["IndexRange"]){$ManualParamsHash["IndexRange"]}elseif($Null -ne $ManualParamsHash["Index"]){$ManualParamsHash["Index"]}
                if($Null -ne $ManualParamsHash["ForegroundColor"]){$ForegroundColorArr = $ManualParamsHash["ForegroundColor"]}
                if($Null -ne $ManualParamsHash["BackgroundColor"]){$BackgroundColorArr = $ManualParamsHash["BackgroundColor"]}
                if($Null -ne $ManualParamsHash["Replace"]){$ReplaceArr = $ManualParamsHash["Replace"]}
                $TermHash = @{}
                for($n = 1; $n -le $SpecifiedTerms; $n++){
                    $TermHash["$($n)"] = [PSCustomObject]@{
                        LineRange = ($LineArr[$n-1] -Split ',')[0]..($LineArr[$n-1] -Split ',')[1]
                        IndexRange = ($IndexArr[$n-1] -Split ',')[0]..($IndexArr[$n-1] -Split ',')[1]
                        ForegroundColor = if($Null -ne $ForegroundColorArr){$ForegroundColorArr[$n-1]}
                        BackgroundColor = if($Null -ne $BackgroundColorArr){$BackgroundColorArr[$n-1]}
                        Replace = if($Null -ne $ReplaceArr){($LineArr[$n-1] -Split ',')[0]}
                        ReplaceWith = if($Null -ne $ReplaceArr){($LineArr[$n-1] -Split ',')[1]}
                    }
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
                            Read-Host $TermHash["$($n)"].BackgroundColor
                            ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).BackgroundColor = $TermHash["$($n)"].BackgroundColor
                        }
                        if($TermHash["$($n)"].Replace -ne '' -and $Null -ne $TermHash["$($n)"].Replace){
                            ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).Character = ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).Character -replace $Replace,$ReplaceWith
                        }
                    }
                }
            }
        } # End Manual Formatting
    } # End Begin
    process{
        fnSetConsoleWinSize -Height ($CharacterGrid.Count+1) -Width $CharacterGrid[1].Length
        Foreach($GridLine in 1..($CharacterGrid.Count)){
            $CharacterGrid[$GridLine] | Foreach-Object {
                if($_.Index -lt $CharacterGrid[$GridLine].Count){
                    if($_.Type -ne "Padding"){
                        Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                    }
                    else{
                        Write-Host "&#xa0;" -NoNewline -ForegroundColor White
                    }
                }
                elseif($_.Index -eq $CharacterGrid[$GridLine].Count){
                    Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                    Write-Host ''
                }
            }
        }
    } #end Process
} # end function
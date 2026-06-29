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
        # Build Reference Hashes
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Global -Name Characters)){
            fnXML "Characters"
        }
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
                    }
                    elseif($CharacterGrid[$LineNumber][$Character.Index-1].Type -eq "Border" -or $CharacterGrid[$LineNumber][$Character.Index+1].Type -eq "Border" -or $CharacterGrid[$LineNumber][$Character.Index-1].Type -eq "Padding" -or $CharacterGrid[$LineNumber][$Character.Index+1].Type -eq "Padding"){
                        $Character.Type = "Border Padding"
                        if($IgnoreBorderPadding -eq $True){
                            $Character.ForegroundColor = "White"
                            $Character.BackgroundColor = "Black"
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
                Character = [int], 0
                IndexRange = [int[]], @()
                Line = [int], 0
                LineRange = [int[]], @()
                ForegroundColor = [String], 'White'
                BackgroundColor = [String], 'Black'
                SelectionType = [String], 'Unspecified'
                Replace = [String], @()
                PaintPadding = [Switch]
            }
            $ManualParamsHash = @{}
            $LineRange = @()
            $IndexRange = @()
            $ManualParamKeys = $ManualParams.Keys
            Foreach($Key in $ManualParamKeys){
                $ManualParamsHash["$Key"] = $ManualParams[$Key].Value
            }
            if($Null -ne $ManualParamsHash["LineRange"]){
                $LineRange += $ManualParamsHash["LineRange"][0]..$ManualParamsHash["LineRange"][1]
            }
            if($Null -ne $ManualParamsHash["Line"]){
                $LineRange += $ManualParamsHash["Line"]
            }
            if($Null -ne $ManualParamsHash["IndexRange"]){
                $IndexRange += $ManualParamsHash["IndexRange"][0]..$ManualParamsHash["IndexRange"][1]
            }
            if($Null -ne $ManualParamsHash["Character"]){
                $IndexRange += $ManualParamsHash["Character"]
            }
            if($Null -ne $ManualParamsHash["Replace"]){
                $Replace = ($ManualParamsHash["Replace"] -Split ',' -replace "'","")[0]
                $ReplaceWith = ($ManualParamsHash["Replace"] -Split ',' -replace "'","")[1]
            }
            # Modify the Character Grid with the Parameters
            foreach($LineNum in $LineRange){
                Foreach($Index in $IndexRange){
                    if($Null -ne $ParamsHash["ForegroundColor"]){
                        ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).ForegroundColor = $ParamsHash["ForegroundColor"]
                    }
                    if($Null -ne $ParamsHash["BackgroundColor"]){
                        ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).BackgroundColor = $ParamsHash["BackgroundColor"]
                    }
                    if($Null -ne $ParamsHash["Replace"]){
                        ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).Character = ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).Character -replace $Replace,$ReplaceWith
                    }
                }
            }
        } # End Manual Formatting
    } # End Begin
    process{
        Foreach($GridLine in 1..($CharacterGrid.Count)){
            $CharacterGrid[$GridLine] | Foreach-Object {
                if($_.Index -lt $CharacterGrid[$GridLine].Count){
                    Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                }
                elseif($_.Index -eq $CharacterGrid[$GridLine].Count){
                    Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                    Write-Host ''
                }
            }
        }
    } #end Process
} # end function
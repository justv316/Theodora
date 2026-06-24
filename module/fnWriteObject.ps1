function fnWriteObject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String] $InputString,
        [ValidateSet("ASCII","String")]
        [String] $ObjectType,
        [String] $Font,
        [ValidateSet("Unspecified","SingleBox","DoubleBox","SingleDoubleBox")]
        [String] $BuildType = "Unspecified",
        [ValidateSet("Center","Left","Right","None")]
        [String] $Justification = "Center",
        [String] $ManualFormatting = '',
        [String] $ColorFormatting = '',
        [String] $MenuFormatting = '',
        [int]$EnforcedMaxLength = 160,
        [int]$MinimumPaddingLength = 4
    )
    <#
    ColorFormatting =  "--ForegroundColor --BackgroundColor --TextForegroundColor --BorderForegroundColor --TextBackgroundColor --BorderBackgroundColor" 
    #>
    begin{
        # Build Reference Hashes
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name $Font)){
            fnXML "$($Font)"
        }
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters)){
            fnXML "Characters"
        }
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Boxes)){
            fnXML "Boxes"
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
            $ColorParamHash = @{}
            $ColorParamKeys = $ColorParams.Keys
            Foreach($Key in $ColorParamKeys){
                $ColorParamHash["$Key"] = $ColorParams[$Key].Value
            }
            # Define Colors
            $IgnoreBorderPadding = if($Null -ne $ColorParamHash["IgnoreBorderPadding"]){$True}else{$False}
            $IgnoreTextPadding = if($Null -ne $ColorParamHash["IgnoreTextPadding"]){$True}else{$False}
            $ForegroundColor = if($Null -ne $ColorParamHash["ForegroundColor"]){$ColorParamHash["ForegroundColor"]}else{"White"}
            $BackgroundColor = if($Null -ne $ColorParamHash["BackgroundColor"]){$ColorParamHash["BackgroundColor"]}else{"Black"}
            $BorderColors = @{"BorderForegroundColor" = $ColorParamHash["BorderForegroundColor"]; "BorderBackgroundColor" = $ColorParamHash["BorderBackgroundColor"]}
            $TextColors = @{"TextForegroundColor" = $ColorParamHash["TextForegroundColor"];"TextBackgroundColor" = $ColorParamHash["TextBackgroundColor"]}
            $TextForegroundColor = if($Null -ne $TextColors["TextForegroundColor"]){$TextColors["TextForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $TextBackgroundColor = if($Null -ne $TextColors["TextBackgroundColor"]){$TextColors["TextBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
            $BorderForegroundColor = if($Null -ne $BorderColors["BorderForegroundColor"]){$BorderColors["BorderForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $BorderBackgroundColor = if($Null -ne $BorderColors["BorderBackgroundColor"]){$BorderColors["BorderBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
        }
        # Build Object
        if($ObjectType -eq "ASCII"){
            $ASCII = fnGetAscii $InputString $Font -BuildType $Buildtype -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
            if($BuildType -ne "Unspecified"){
                $ConstructedASCII = fnBuildObject -InputObject $ASCII -BuildType -ObjectType "Boxed" $BuildType -Justification $Justification -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
            }
            $GridInput = if($ConstructedASCII -ne '' -and $Null -ne $ConstructedASCII){$ConstructedASCII}else{$ASCII}
        }
        elseif($ObjectType -eq "String"){
            if($BuildType -ne "Unspecified"){
                $ConstructedString = fnBuildObject -InputObject $InputString -BuildType $BuildType -ObjectType "Boxed" -Justification $Justification -EnforcedMaxLength $EnforcedMaxLength -MinimumPaddingLength $MinimumPaddingLength
            }
            $GridInput = if($ConstructedString -ne '' -and $Null -ne $ConstructedString){$ConstructedString}else{$InputString}
        }
        $LineCount = $GridInput.Length
        if($BuildType -ne "Unspecified"){
            #Get the number of Borderlines - Will always be at least the first and last lines
            $BorderLines = @(1, $GridInput.Length)
            $BorderColumns = @(1, $GridInput[0].Length) 
            #If there are more BorderLines, we add them to the array
            if(($Boxes[$($BuildType)])["OuterBorderLines"] -gt 1){
                $BorderLines += ($Boxes[$($BuildType)])["OuterBorderLines"]
                $BorderLines += $GridInput.Length - 1
                $BorderColumns += ($Boxes[$($BuildType)])["OuterBorderLines"]
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
                    elseif($Borderlines -contains $LineNumber -or $BorderColumns -Contains $CharNumber){"Border"}
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
            $ManualParamHash = @{}
            $LineRange = @()
            $IndexRange = @()
            $ManualParamKeys = $ManualParams.Keys
            Foreach($Key in $ManualParamKeys){
                $ManualParamHash["$Key"] = $ManualParams[$Key].Value
            }
            if($Null -ne $ManualParamHash["LineRange"]){
                $LineRange += $ManualParamHash["LineRange"][0]..$ManualParamHash["LineRange"][1]
            }
            if($Null -ne $ManualParamHash["Line"]){
                $LineRange += $ManualParamHash["Line"]
            }
            if($Null -ne $ManualParamHash["IndexRange"]){
                $IndexRange += $ManualParamHash["IndexRange"][0]..$ManualParamHash["IndexRange"][1]
            }
            if($Null -ne $ManualParamHash["Character"]){
                $IndexRange += $ManualParamHash["Character"]
            }
            if($Null -ne $ManualParamHash["Replace"]){
                $Replace = ($ManualParamHash["Replace"] -Split ',' -replace "'","")[0]
                $ReplaceWith = ($ManualParamHash["Replace"] -Split ',' -replace "'","")[1]
            }
            # Modify the Character Grid with the Parameters
            foreach($LineNum in $LineRange){
                Foreach($Index in $IndexRange){
                    if($Null -ne $ParamHash["ForegroundColor"]){
                        ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).ForegroundColor = $ParamHash["ForegroundColor"]
                    }
                    if($Null -ne $ParamHash["BackgroundColor"]){
                        ($CharacterGrid[$LineNum] | Where-Object {$_.Index -eq $Index}).BackgroundColor = $ParamHash["BackgroundColor"]
                    }
                    if($Null -ne $ParamHash["Replace"]){
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
    end{
        Remove-Variable ManualFormatting -ErrorAction SilentlyContinue
        Remove-Variable ColorFormatting -ErrorAction SilentlyContinue
        Remove-Variable ASCII -ErrorAction SilentlyContinue
        Remove-Variable ConstructedASCII -ErrorAction SilentlyContinue
        Remove-Variable CharacterGrid -ErrorAction SilentlyContinue
    }
} # end function
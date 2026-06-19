function fnWriteManual {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String[]] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [String] $ManualFormatting,
        [String] $BuildType = "Unspecified",
        [String] $SelectionType = "Unspecified",
        [Hashtable] $ColorParamHash = @{}
    )
    <# USAGE
        Specify a specific character to modify: --Character 10 --Line 1 --Foreground Red
        Specify a range of characters to modify on a single line: --IndexRange=10 15 --Line=1 --Foreground Red --Background White
        Specify a range of lines and a range of characters --IndexRange=4 7 --LineRange=3 4 --Background Yellow
        Specify a character to find and replace in the specified range --replace ' ' '@'
        SelectionType : Specifies if a full element should be selected (Example: An entire single ASCII Character) 
            Unspecified: Will select just the specified characters/lines.
            FullWord: Will select the full word found at the characters location.
            FullCharacter: Will select the full ASCII character found at the characters location.
        IgnorePadding - Ignores Padding characters when coloring
        $ManualFormatting = "--Character=10 --IndexRange=10 15 --Line=1 --LineRange=1 2 --replace ' ','@' --Foreground Red --Background Black --SelectionType=FullCharacter --IgnorePadding"
        Character and line numbers are indexes of an array starting at 0
        If just a Linerange is specified, that entire line will be modified
        $Foreground and BackgroundColor: If specified will perform normal behavior on that specific component. Allows for, example, specifying a characters Foreground color, while leaving the background color subject to a previous statement
    #>
    begin{
        # Create Param Hash
        $ManualFormattingArr = $ManualFormatting -Split ' '
        $Params = ConvertTo-Params $ManualFormattingArr -schema @{
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
        $ParamHash = @{}
        $LineRange = @()
        $IndexRange = @()
        $Segmented = $False
        $ParamKeys = $Params.Keys
        Foreach($Key in $ParamKeys){
            $ParamHash["$Key"] = $Params[$Key].Value
        }
        if($Null -ne $ParamHash["LineRange"]){
            $LineRange += $ParamHash["LineRange"][0]..$ParamHash["LineRange"][1]
        }
        if($Null -ne $ParamHash["Line"]){
            $LineRange += $ParamHash["Line"]
        }
        if($Null -ne $ParamHash["IndexRange"]){
            $IndexRange += $ParamHash["IndexRange"][0]..$ParamHash["IndexRange"][1]
        }
        if($Null -ne $ParamHash["Character"]){
            $IndexRange += $ParamHash["Character"]
        }
        if($Null -ne $ParamHash["Replace"]){
            $Replace = ($ParamHash["Replace"] -Split ',' -replace "'","")[0]
            $ReplaceWith = ($ParamHash["Replace"] -Split ',' -replace "'","")[1]
        }
        if($ColorParamHash.Count -gt 0){
            $GeneralColor = $False
            $SpecificColor = $False
            $GeneralColor = ($Null -ne $ColorParams["ForegroundColor"] -or $Null -ne $ColorParams["BackgroundColor"])
            $SpecificColor = ($Null -ne $ColorParams["TextForegroundColor"] -or $Null -ne $ColorParams["TextBackgroundColor"] -or $Null -ne $ColorParams["BorderForegroundColor"] -or $Null -ne $ColorParams["BorderBackgroundColor"])
            if($GeneralColor -eq $True -and $SpecificColor -eq $True){
                Throw "We cannot specify both a general color and a specific color at the same time"
                return
            }
            $BorderColors = @{"BorderForegroundColor" = $ColorParamHash["BorderForegroundColor"]; "BorderBackgroundColor" = $ColorParamHash["BorderBackgroundColor"]}
            $TextColors = @{"TextForegroundColor" = $ColorParamHash["TextForegroundColor"]; "TextBackgroundColor" = $ColorParamHash["TextBackgroundColor"]}
            $TextForegroundColor = if($Null -ne $TextColors["TextForegroundColor"]){$TextColors["TextForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $TextBackgroundColor = if($Null -ne $TextColors["TextBackgroundColor"]){$TextColors["TextBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
            $BorderForegroundColor = if($Null -ne $BorderColors["BorderForegroundColor"]){$BorderColors["BorderForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $BorderBackgroundColor = if($Null -ne $BorderColors["BorderBackgroundColor"]){$BorderColors["BorderBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
            $ForegroundColor = if($Null -ne $ColorParamHash["ForegroundColor"]){$ColorParamHash["ForegroundColor"]}else{"White"}
            $BackgroundColor = if($Null -ne $ColorParamHash["BackgroundColor"]){$ColorParamHash["BackgroundColor"]}else{"Black"}
            $Segmented = if($SpecificColor -eq $True){$True}else{$False}
        }
        else{
            $BackgroundColor = 'Black'
            $ForegroundColor = 'White'
        }

        if($BuildType -ne "Unspecified"){
            $BorderLines = @(
                1, $ConstructedASCII.Length
            )
            #If there are more BorderLines, we add them to the array
            if(($Boxes[$($BuildType)])["OuterBorderLines"] -gt 1){
                $BorderLines += ($Boxes[$($BuildType)])["OuterBorderLines"]
                $BorderLines += $ConstructedASCII.Length - 1
            }
            $BorderColumns = @(
                1, $ConstructedASCII[0].Length
            )
            if(($Boxes[$($BuildType)])["OuterBorderLines"] -gt 1){
                $BorderColumns += ($Boxes[$($BuildType)])["OuterBorderLines"]
                $BorderColumns += $ConstructedASCII[0].Length - 1
            }
        }
        # Create the Grid
        $CharacterGrid = [System.Collections.SortedList]::new()
        Foreach($LineNumber in 1..($InputObject.Count)){
            $CharacterGrid[$LineNumber] = @()
            $LineArray = [Char[]]$InputObject[$LineNumber-1]
            $CharNumber = 1
            foreach($Char in $LineArray){
                $CharacterType = if($Char -eq ' '){"Padding"}
                elseif($Borderlines -contains $LineNumber -or $BorderColumns -Contains $CharNumber){"Border"}
                else{"Character"}
                if($Segmented -eq $True){
                    if($CharacterType -eq "Border"){
                        $ForegroundColor = $BorderForegroundColor
                        $BackgroundColor = $BorderBackgroundColor
                    }
                    elseif($CharacterType -eq "Character"){
                        $ForegroundColor = $TextForegroundColor
                        $BackgroundColor = $TextBackgroundColor
                    }
                    elseif($CharacterType -eq "Padding"){
                        $BackgroundColor = 'Black'
                        $ForegroundColor = 'White'
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
        # Modify the Character Grid with the Parameters
        if($SelectionType -eq "Unspecified"){
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
        }
    } # end Begin
    process{
        if($Segmented){
            # Segmented ASCII needs to be handled differently?
        }
        else{
            # Write the contents of the grid
            Foreach($GridLine in 1..($CharacterGrid.Count)){
                $CharacterGrid[$GridLine] | Foreach-Object {
                    if($_.Index -lt $CharacterGrid[$GridLine].Count){
                        Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                    }
                    else{
                        Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor
                    }
                }
            }
        }

    } # end Process
}

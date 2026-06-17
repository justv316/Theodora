function fnWriteManual {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [String] $ManualFormatting,
        [String] $BuildType,
        [String] $SelectionType = "Unspecified",
        [Switch] $Segmented,
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $ForegroundColor = 'Default',
        [ValidateSet("Black", "Blue", "Cyan", "DarkBlue", "DarkCyan", "DarkGray", "DarkGreen", "DarkMagenta", "DarkRed", "DarkYellow", "Default", "Gray", "Green", "Magenta", "Red", "Rainbow", "White", "Yellow")]
        [String] $BackgroundColor = 'Default'
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
        $ManualFormatting = "--Character=10 --IndexRange=10 15 --Line=1 --LineRange=1 2 --replace ' ','@' --Foreground Red --Background Black --SelectionType=FullCharacter"
        Character and line numbers are indexes of an array starting at 0
        If just a Linerange is specified, that entire line will be modified
        $Foreground and BackgroundColor: If specified will perform normal behavior on that specific component. Allows for, example, specifying a characters Foreground color, while leaving the background color subject to a previous statement
    #>
    begin{
        # Create Param Hash
        $ManualFormatting = $ManualFormatting -Split ' '
        $Params = ConvertTo-Params $ManualFormatting -schema @{
            Character = [int], 0
            IndexRange = [int[]], @()
            Line = [int], 0
            LineRange = [int[]], @()
            Foreground = [String], 'White'
            Background = [String], 'Black'
            SelectionType = [String], 'Unspecified'
            Replace = [String], @()
        }
        $ParamHash = @{}
        $LineRange = @()
        $IndexRange = @()
        $ParamKeys = $Params.Keys
        Foreach($Key in $ParamKeys){
            $ParamHash["$Key"] = $Params[$Key].Value
        }
        if($Null -ne $ParamHash["LineRange"] -or $Null -ne $ParamHash["Line"]){
            $LineRange += $ParamHash["LineRange"][0]..$ParamHash["LineRange"][1]
            $LineRange += $ParamHash["Line"]
        }
        if($Null -ne $ParamHash["IndexRange"] -or $Null -ne $ParamHash["Character"]){
            $IndexRange += $ParamHash["IndexRange"][0]..$ParamHash["IndexRange"][1]
            $IndexRange += $ParamHash["Character"]
        }
        if($Null -ne $ParamHash["Replace"]){
            $Replace = ($ParamHash["Replace"] -Split ',' -replace "'","")[0]
            $ReplaceWith = ($ParamHash["Replace"] -Split ',' -replace "'","")[1]
        }
        # Create the Grid
        $CharacterGrid = [System.Collections.SortedList]::new()
        $LineArray = @()
        Foreach($LineNumber in 0..($InputObject.Count - 1)){
            $CharacterGrid[$LineNumber] = @()
            $LineArray = [Char[]]$InputObject[$LineNumber]
            $CharNumber = 0
            foreach($Char in $LineArray){
                $Chars = [PSCustomObject] @{
                    'Index' = $CharNumber
                    'Line' = $LineNumber
                    'Character' = "$Char"
                    'Foreground' = 'White'
                    'Background' = 'Black'
                }
                $CharNumber++
                $CharacterGrid[$LineNumber] += $Chars
            }
        }
        # Modify the Character Grid with the Parameters
        foreach($Line in $LineRange){
            # We have no idea why this produces errors, it does the modifications... Putting it in a Try catch block for now lol
            try{
            Foreach($Index in $IndexRange) {
                if($Null -ne $ParamHash["Foreground"]){
                    ($CharacterGrid[$Line] | Where-Object {$_.Index -eq $Index}).Foreground = $ParamHash["Foreground"]
                }
                if($Null -ne $ParamHash["Background"]){
                    ($CharacterGrid[$Line] | Where-Object {$_.Index -eq $Index}).Background = $ParamHash["Background"]
                }
                if($Null -ne $ParamHash["Replace"]){
                    ($CharacterGrid[$Line] | Where-Object {$_.Index -eq $Index}).Character = ($CharacterGrid[$Line] | Where-Object {$_.Index -eq $Index}).Character -replace $Replace,$ReplaceWith
                }
                }
            }
            Catch{}
        }
    } # end Begin
    process{
        if($Segmented){
            # Segmented ASCII needs to be handled differently?
        }
        else{
            # Write the contents of the grid
            Foreach($GridLine in 0..($CharacterGrid.Count - 1)){
                $CharacterGrid[$GridLine] | Foreach-Object {
                    if($_.Index -lt $CharacterGrid[$GridLine].Count - 1){
                        Write-Host $_.Character -ForegroundColor $_.Foreground -BackgroundColor $_.Background -NoNewline
                    }
                    else{
                        Write-Host $_.Character -ForegroundColor $_.Foreground -BackgroundColor $_.Background
                    }
                }
            }
        }

    } # end Process
}

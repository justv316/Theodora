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
        $ManualFormatting = "--Character=10 --IndexRange=10 15 --Line=1 --LineRange=1 2 --replace ' ' '@' --Foreground Red --Background Black --SelectionType=FullCharacter"
        Character and line numbers are indexes of an array starting at 0
        If just a Linerange is specified, that entire line will be modified
        $Foreground and BackgroundColor: If specified will perform normal behavior on that specific component. Allows for, example, specifying a characters Foreground color, while leaving the background color subject to a previous statement
    #>
    begin{
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
        $ParamKeys = $Params.Keys
        Foreach($Key in $ParamKeys){
            $ParamHash["$Key"] = $Params[$Key].Value
        }
        $CharacterGrid = [System.Collections.SortedList]::new()
        $LineArray = @()
        $LineRange = @()
        $IndexRange = @()
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
        if($Null -ne $ParamHash["LineRange"] -or $Null -ne $ParamHash["Line"]){
            $LineRange += $ParamHash["LineRange"][0]..$ParamHash["LineRange"][1]
            $LineRange += $ParamHash["Line"]
        }
        if($Null -ne $ParamHash["IndexRange"] -or $Null -ne $ParamHash["Character"]){
            $IndexRange += $ParamHash["IndexRange"][0]..$ParamHash["IndexRange"][1]
            $IndexRange += $ParamHash["Character"]
        }

       
        $LineRange | Foreach-Object {
            $Line = $_ -as [int]
            $IndexRange | Foreach-Object {
                $Character = $_ -as [int]
                if($Null -ne $ParamHash["Foreground"]){
                    ($CharacterGrid[$Line] | Where-Object {$_.Index -eq $Character}).Foreground = $ParamHash["Foreground"]
                }
                elseif($Null -ne $ParamHash["Background"]){
                    $CharObj.Background = $ParamHash["Background"]
                }
                <#elseif($Null -ne $ParamHash["Replace"]){

                }#>
            }
        }

    } # end Begin
    process{
        if($Segmented){
            # Segmented ASCII needs to be handled differently?
        }
        else{
            # Non-Segmented ASCII or String

        }

    } # end Process
}

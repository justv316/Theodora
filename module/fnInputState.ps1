function fnInputState{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [String] $State,
        [String] $SubState
    )
    <# This script controls the InputState - how the game progresses
    #>
    begin{
        if($Null -eq $States){
            fnXML "States"
        }

    }
    process{
        if(!($Null -ne $SubState -and $Substate -ne '')){
           fnWriteObject -InputObject $States["$State"].StateGrid -ObjectFormatting $States["$State"].ObjectFormatting
           $ActiveState = $States["$State"]
           # Need to re-write "FnWriteObject" to Accept a character grid and color formatting, modify it, and write the results
           # Need to write "FnBuildGrid" to build the character grid and store it into a 'Prefabrication' object on the State
        }
        [String]$PlayerResponse = Read-Host "::"
        $SubStates = $States[$State].PSObject.Properties | Where-Object {$_.Name -like "SubState*"} | Select-Object Name
        foreach($num in 0..($SubStates.Count - 1)){
            $SubStates[$Num] | Select-Object Name | Foreach-Object {$SubStates[$Num] = $_.Name -replace "Substate-",""}
        }
        if($SubStates -Contains $PlayerResponse){
            $SubState = "Substate-" + $PlayerResponse
            fnWriteObject -InputObject $ActiveState.SubstateGrid -ObjectFormatting $ActiveState.ObjectFormatting
            $ActiveState = $ActiveState.$SubState
        }
        [String]$PlayerResponse = Read-Host "::"
    }

}
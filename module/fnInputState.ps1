function fnInputState{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [String] $State
    )
    begin{
        $ValidStates = $States.Keys
    }
    process{
        if($ValidStates -Contains $State){
            fnWriteObject -InputObject $States["$State"].StateGrid -ObjectFormatting $States["$State"].ObjectFormatting
            $Script:Active = $True
            $Script:ActiveState = $States["$State"]
            $Script:ActiveStateString = $State
            fnReadInput
        }
        else{
            Throw "Invalid State! Exception: $($State)"
        }
    }
}
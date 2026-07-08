function fnReadInput{
    [CmdletBinding()]
    param(
    )
    begin{
        $ValidCommands = $ActiveState.ValidCommands -Split ','
    }
    process{
        [String]$PlayerResponse = Read-Host ":="
        if($ValidCommands -contains $PlayerResponse){
            $SubState = $ActiveState.Index+"$PlayerResponse"
            fnInputState -State $SubState
        }
        elseif($PlayerResponse -eq "Back"){
            fnInputState $ActiveState.Parent
        }
        else{
            Throw "Invalid Command!"
            fnReadInput
        }
    }
}
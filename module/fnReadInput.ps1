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
            fnwriteObject -inputobject "Invalid Command!" -ObjectFormatting "--InputType=String --BorderType=Single --Justification=Center --EnforcedMaxLength=80 --MinimumPaddingLength=4" -ColorFormatting "--TextForegroundColor=Red --TextBackgroundColor=Black --BorderForegroundColor=Blue --BorderBackgroundColor=White --IgnoreTextPadding" -IgnoreConsole
            fnReadInput
        }
    }
}
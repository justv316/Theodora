function fnInputState{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [String] $State,
        [String] $SubState
    )
    <# This script controls the InputState - how the game progresses
    
    SubStates = @{
                    "1" = [PSCustomObject]@{
                        SimpleName = "New Game"
                        Execution = {fnInputState 0 1}
                    }
                    "2" = [PSCustomObject]@{
                        SimpleName = "Load Game"
                        Execution = {fnInputState 0 2}
                    }
                    "3" = [PSCustomObject]@{
                        SimpleName = "Options"
                        Execution = {fnInputState 0 3}
                    }
                    "4" = [PSCustomObject]@{
                        SimpleName = "Credits"
                        Execution = {fnInputState 0 4}
                    }
                }
    
    #>
    begin{
        $UniversalInput = @("Help", "Exit")
        $States = @{
            "0" = [PSCustomObject]@{
                SimpleName = "MainMenu"
                Display = {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=Main_Menu --HeadersFont=Large --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=1.New_Game_2.Load_Game_3.Options_4.Credits --ButtonsFont=Graceful --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=Center" -ColorFormatting "--BorderForegroundColor Magenta" -ManualFormatting "--IndexRange=32,88 29,93 --LineRange=3,8 13,28 --ForegroundColor=blue green"}
            }
        }

    }
    process{
        if($Null -ne $SubState -and $Substate -ne ''){
           & $States["$State"].ValidInput[$SubState]
        }
        else{
           & $States["$State"].Display
        }
        $PlayerResponse = Read-Host "::"

    }

}
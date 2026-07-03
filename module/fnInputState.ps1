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
        if($Null -eq $Strings){
            fnXML "Strings"
        }
        $States = @{
            "0" = [PSCustomObject]@{
                SimpleName = "MainMenu"
                SubStates = @{
                    "1" = [PSCustomObject]@{
                        SimpleName = "NewGame"
                    }
                    "2" = [PSCustomObject]@{
                        SimpleName = "LoadGame"
                    }
                    "3" = [PSCustomObject]@{
                        SimpleName = "Options"
                        Display = {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=80 --MinimumPaddingLength=0" -BuildFormatting "--ObjectType=Grid --Justification=Left" -GridFormatting "--GridColumns=2 --GridBorder=Double --GridJustification=Left --Headers=Options --HeadersFont=Graceful --HeadersBorder=Double --HeadersObjectBorder=Single --HeadersJustification=Left --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=Option_1 Detail_1 --ButtonsFont=None None --ButtonsBorder=Single Single --ButtonsObjectBorder=None None --ButtonsJustification=None Right" -ColorFormatting "--BorderForegroundColor Magenta"}
                    }
                    "4" = [PSCustomObject]@{
                        SimpleName = "Credits"
                        Display = {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=0" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Left --Buttons=Scipting,_ASCII,_etc. Fox --ButtonsFont=None Graceful --ButtonsBorder=Single Single --ButtonsObjectBorder=None None --ButtonsJustification=Center Center" -ColorFormatting "--BorderForegroundColor Red --TextForegroundColor White"}
                    }
                    "Help" = [PSCustomObject]@{
                        SimpleName = "Help"
                        Display = {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=80 --MinimumPaddingLength=0" -BuildFormatting "--ObjectType=Grid --Justification=Left" -GridFormatting "--GridColumns=2 --GridBorder=Double --GridJustification=Left --Buttons=Valid_Inputs --ButtonsFont=None --ButtonsBorder=Single --ButtonsObjectBorder=None --ButtonsJustification=Left" -ColorFormatting "--BorderForegroundColor Green"}
                    }
                    "Exit" = [PSCustomObject]@{
                        SimpleName = "Exit"
                        Display = {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=160 --MinimumPaddingLength=0" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Buttons=Thank_You_for_Playing_my_Game --ButtonsFont=Graceful --ButtonsBorder=Single --ButtonsObjectBorder=None --ButtonsJustification=Center" -ColorFormatting "--BorderForegroundColor Red --TextForegroundColor Magenta"}
                    }
                }
                Display = {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=$($Strings['MainMenu_Headers'].String) --HeadersFont=$($Strings['MainMenu_Headers'].Font) --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=$($Strings['MainMenu_Buttons'].String) --ButtonsFont=$($Strings['MainMenu_Buttons'].Font) --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=Center" -ColorFormatting "--BorderForegroundColor Magenta" -ManualFormatting "--IndexRange=32,88 29,93 --LineRange=3,8 13,28 --ForegroundColor=blue green"}
            }
        }

    }
    process{
        if(!($Null -ne $SubState -and $Substate -ne '')){
           & $States["$State"].Display
           $ActiveState = $States["$State"]
        }
        else{
        }
        [String]$PlayerResponse = Read-Host "::"
        if($ActiveState.SubStates.Keys -Contains $PlayerResponse){
            & $ActiveState.SubStates[$PlayerResponse].Display
            $ActiveState = $ActiveState.SubStates[$PlayerResponse]
        }
        [String]$PlayerResponse = Read-Host "::"
    }

}
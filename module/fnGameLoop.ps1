<# This Script controls the Inputstate of the game and works in tandem with fnDisplayGame 
to accurately project the game state

Common States: 
    #_0 - Invalid Input Error
    #_0_0 - Help Message
    #_-1 - Game Termination  
#>


function fnGameLoop{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$State = 0
    )
    $fnState_0 = {
        $ValidInput = @("start","help")
        $In = Read-Host ":"
        if($ValidInput -Contains $In){
            if($In -eq "start"){
                &fnGameLoop 1
            }
            else{
                &fnGameLoop 0
            }
        }
        else{
            &fnGameLoop 0_0
        }
    }
    $fnState_1 = {
        $ValidInput = @("1","2","3","4","help")
        $In = Read-Host ":"
        if(1..4 -eq $In){
            &fnGameLoop 1_$In
        }
        else{
            &fnGameLoop 1_0
        }

    }
    if($State -eq 0){
        &fnDisplayGame $State
        &$fnState_0
    }
    elseif($State -eq "0_0"){
        &fnDisplayGame $State
        &$fnState_0
    }
    elseif($State -eq 1){
        &fnDisplayGame $State
        &$fnState_1
    }
    elseif($State -eq "1_0"){
        &fnDisplayGame $State
        &$fnState_1
    }
    #NewGame
    elseif($State -eq "1_1"){
        Read-Host "State 1_1"
    }
    #LoadGame
    elseif($State -eq "1_2"){
        Read-Host "State 1_2"
    }
    #Settings
    elseif($State -eq "1_3"){
        Read-Host "State 1_3"
    }
    #Help
    elseif($State -eq "1_4"){
        Read-Host "State 1_4"
    }
}
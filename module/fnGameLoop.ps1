<# This Script controls the Inputstate of the game and works in tandem with fnDisplayGame 
to accurately project the game state

    #_$_^
    # = Main State Index (e.g Main Menu)
    $ = Sub State Categorization (e.g Informational)
    ^ = Sub State Index (e.g Error, Help)
Common States: 
    #_0_0 - Invalid Input Error
    #_0_1 - Help Message
    #_-1 - Game Termination  
#>


function fnGameLoop{
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$State = 0
    )


    $fnState_0 = {
        $ValidInput = @("start","help","exit")
        $In = Read-Host ":"
        if($ValidInput -Contains $In){
            if($In -eq "start"){
                &fnGameLoop 1
            }
            elseif($In -eq "help"){
                &fnGameLoop 0_0_1
            }
            elseif($In -eq "exit"){
                &fnGameLoop 0_0_2
            }
            else{
                &fnGameLoop 0_0_0
            }
        }
        else{
            &fnGameLoop 0_0_0
        }
        
    }




    $fnState_1 = {
        $ValidInput = @("1","2","3","4","help","exit")
        $In = Read-Host ":"
        if($ValidInput -Contains $In){
            if(1..4 -eq $In){
                &fnGameLoop 1_$In
            }
            elseif($In -eq "help"){
                &fnGameLoop 1_0_1
            }
            elseif($In -eq "exit"){
                &fnGameLoop 0_0_2
            }
            else{
                &fnGameLoop 1_0_0
            }
        }
        else{
            &fnGameLoop 1_0_0
        }

    }

    $fnState_0_2 = {
        Read-Host "Press enter to quit"
        exit
    }

    $ValidState_1 = @("1","1_0_0", "1_0_1")
    $ValidState_0 = @("0","0_0_0", "0_0_1", "0_0_2")

    if($ValidState_0 -Contains $State){
        &fnDisplayGame $State
        if($State -eq "0_0_2"){
            &$fnState_0_2
        }
        else{
            &$fnState_0
        }
    }
    elseif($ValidState_1 -Contains $State){
        &fnDisplayGame $State
        &$fnState_1
    }
    else{
        Write-Host "Seemingly a critical error has occured"
        Write-Host "Attempted to load $State"
        Read-Host ":"
    }
}
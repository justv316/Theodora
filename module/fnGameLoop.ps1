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
Major States:
    0 - Splash Screen
    1 - Main Menu
    2 - New Game
#>


function fnGameLoop{
    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$State = 0
    )
    #SplashScreen
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
    # MainMenu
    $fnState_1 = {
        $ValidInput = @("1","2","3","4","help","exit")
        $In = Read-Host ":"
        if($ValidInput -Contains $In){
            if($In -eq "1"){
                &fnGameLoop 2
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

    #NewGameSaveLoad
    $fnState_2 = {
        if($State -eq "2"){
            &fnCreateNewCharacter
        }
        elseif($State -eq "2_1_0"){
            $ValidInput = @("Y","N","exit")
            $In = Read-Host ":"
            if($ValidInput -Contains $In){
                if($In -eq "Y"){
                    &fnWriteSave 1
                }
                elseif($In -eq "N"){
                    &$fnGameLoop 1
                }
                elseif($In -eq "Exit"){
                    &fnGameLoop 0_0_2
                }
                else{
                    &fnGameLoop 2_0_0
                }
            }
        }
        elseif($State -eq "2_1_1"){
            $ValidInput = @("1","2","3","exit")
            $In = Read-Host "2_1_1:"
            if($ValidInput -Contains $In){
                if(1..3 -eq $In){
                    &fnWriteSave $In
                }
                elseif($In -eq "Exit"){
                    &fnGameLoop 0_0_2
                }
                else{
                    &fnGameLoop 2_0_0
                }
            }

        }
        elseif($State -eq "2_1_2"){
            $ValidInput = @("1","2","3","exit")
            $In = Read-Host "2_1_2:"

        }
    }

    $fnState_3 = {
        $ValidInput = @("Y","N")
        $In = Read-Host "3:"
    }

    $ValidState_0 = @("0","0_0_0", "0_0_1", "0_0_2")
    $ValidState_1 = @("1","1_0_0", "1_0_1")
    $ValidState_2 = @("2", "2_1", "2_1_0", "2_1_1","2_1_2","2_0_0")
    $ValidState_3 = @("3")

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
    elseif($ValidState_2 -Contains $State){
        &fnDisplayGame $State
        &$fnState_2
    }
    elseif($ValidState_3 -Contains $State){
        &fnDisplayGame $State
        &$fnState_3
    }
    else{
        Write-Host "Seemingly a critical error has occured"
        Write-Host "Attempted to load $State"
        Read-Host ":"
    }
}
<# This Script controls the DisplayState of the game and works in tandem with fnGameLoop
to accurately project the game state

Common States: 
    #_0 - Invalid Input Error
    #_0_0 - Help Message
    #_-1 - Game Termination  
#>

function fnDisplayGame{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [String]$DisplayResult = 0
    )
    $BorderTop = {Write-Host "╔~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╗";}
    $BorderBottom = {Write-Host "╚~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╝";}
    $BorderContinuation = {Write-Host "╠~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╣";}
    $EmptySpace = {Write-Host "║                                                                              ║";}
    $InnerBoxTop = {Write-Host "║┌────────────────────────────────────────────────────────────────────────────┐║";}
    $InnerBoxBottom = {Write-Host "║└────────────────────────────────────────────────────────────────────────────┘║";}
    $InnerBoxMiddle = {Write-Host "║├────────────────────────────────────────────────────────────────────────────┤║";}

    $InvalidInput = {
        $ErrorInput = {Write-Host "║     Error: Invalid Input! Type 'help' for valid commands at this field.      ║";}
        &$BorderTop
        &$ErrorInput
        &$BorderBottom
    }
    $SplashScreen = {
        $SplashBorder = {
            $InnerBorderTop = {Write-Host "║   )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )  ║";}
            $InnerBorderBottom = {Write-Host "║  (  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(   ║";}
            &$InnerBorderTop
            &$InnerBorderBottom
    }
        $TheodoraSplash = {
            $TheodoraLineOne = {Write-Host "║   )\  ) ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  )\  )  ║";}
            $TheodoraLineTwo = {Write-Host "║  (  \(  ┃      _______ _                    _                      ┃ (  \(   ║";}
            $TheodoraLineThree = {Write-Host "║   )\  ) ┃     |__   __| |                  | |                     ┃  )\  )  ║";}
            $TheodoraLineFour = {Write-Host "║  (  \(  ┃        | |  | |__   ___  ___   __| | ___  _ __ __ _      ┃ (  \(   ║";}
            $TheodoraLineFive = {Write-Host "║   )\  ) ┃        | |  | '_ \ / _ \/ _ \ / _' |/ _ \| '__/ _' |     ┃  )\  )  ║";}
            $TheodoraLineSix = {Write-Host "║  (  \(  ┃        | |  | | | |  __/ (_) | (_| | (_) | | | (_| |     ┃ (  \(   ║";}
            $TheodoraLineSeven = {Write-Host "║   )\  ) ┃        |_|  |_| |_|\___|\___/ \__,_|\___/|_|  \__,_|     ┃  )\  )  ║";}
            $TheodoraLineEight = {Write-Host "║  (  \(  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ (  \(   ║";}
            &$TheodoraLineOne
            &$TheodoraLineTwo
            &$TheodoraLineThree
            &$TheodoraLineFour
            &$TheodoraLineFive
            &$TheodoraLineSix
            &$TheodoraLineSeven
            &$TheodoraLineEight
    }
        $SplashBox = {
            $InnerBoxSegmentedTop = {Write-Host "║  ┌────────────┬──────────────┬──────────────────────┬─────────────────────┐  ║";}
            $InnerBoxSegmentedBottom = {Write-Host "║  └────────────┴──────────────┴──────────────────────┴─────────────────────┘  ║";}
            $InnerBoxSegmentedSplash = {Write-Host "║  │ By The Fox │ Version: 0.0 │ BuildDate: 5-24-2026 │ Pre-Release         │  ║";}
            &$InnerBoxSegmentedTop
            &$InnerBoxSegmentedSplash
            &$InnerBoxSegmentedBottom
    }
        $StartBox = {
            $InnerBoxMiddleStart = {Write-Host "║│                           <Enter Start to Begin>                           │║";}
            &$InnerBoxTop
            &$InnerBoxMiddleStart
            &$InnerBoxBottom
    }
        Clear-Host;
        &$BorderTop
        &$EmptySpace
        &$SplashBorder
        &$TheodoraSplash
        &$SplashBorder
        &$SplashBox
        &$EmptySpace
        &$BorderContinuation
        &$StartBox
        &$BorderBottom
    }
    $Menu = {
            $MenuOne = {Write-Host "║│ 1. New Game                                                                │║";}
            $MenuTwo = {Write-Host "║│ 2. Load Game                                                               │║";}
            $MenuThree = {Write-Host "║│ 3. Settings                                                                │║";}
            $MenuFour = {Write-Host "║│ 4. Help                                                                    │║";}
            &$BorderTop
            &$InnerBoxTop
            &$MenuOne
            &$InnerBoxMiddle
            &$MenuTwo
            &$InnerBoxMiddle
            &$MenuThree
            &$InnerBoxMiddle
            &$MenuFour
            &$InnerBoxBottom
            &$BorderContinuation
        }
    $Disclaimer = {
            $DisclaimerOne = {Write-Host "║               IMPORTANT: DO NOT RESIZE THE GAME WINDOW AT ALL!               ║";}
            $DisclaimerTwo = {Write-Host "║            THE GAME WILL RESIZE THE CONSOLE HOST WINDOW AS NEEDED            ║";}
            $DisclaimerThree = {Write-Host "║    RESIZING THE WINDOW MANUALLY OR ATTEMPTING TO FULLSCREEN WILL BREAK IT    ║";}
            &$DisclaimerOne
            &$DisclaimerTwo
            &$DisclaimerThree
            &$BorderContinuation
        }
    $SmallTheodora = {
            $SmallTheodoraOne = {Write-Host "║│                  _____ _  _ ___ ___  ___   ___  ___    _                   │║";}
            $SmallTheodoraTwo = {Write-Host "║│                 |_   _| || | __/ _ \|   \ / _ \| _ \  /_\                  │║";}
            $SmallTheodoraThree = {Write-Host "║│                   | | | __ | _| (_) | |) | (_) |   / / _ \                 │║";}
            $SmallTheodoraFour = {Write-Host "║│                   |_| |_||_|___\___/|___/ \___/|_|_\/_/ \_\                │║";}
            &$InnerBoxTop
            &$SmallTheodoraOne
            &$SmallTheodoraTwo
            &$SmallTheodoraThree
            &$SmallTheodoraFour
            &$InnerBoxBottom
            &$BorderBottom
        }
    $MainMenu = {
        Clear-Host;
        &$Menu
        &$Disclaimer
        &$SmallTheodora
    }

    if($DisplayResult -eq 0){
        &fnSetConsoleWinSize -Width 80 -Height 24
        fnSetConsoleWinColor -Background Black -Foreground White
        &$SplashScreen
    }
    if($DisplayResult -eq "0_0"){
        &fnSetConsoleWinSize -Width 80 -Height 27
        &$SplashScreen
        &$InvalidInput
    }
    if($DisplayResult -eq 1){
        &fnSetConsoleWinSize -Width 80 -Height 23
        &$MainMenu
    }
    if($DisplayResult -eq "1_0"){
        &fnSetConsoleWinSize -Width 80 -Height 26
        &$MainMenu
        &$InvalidInput
    }
}
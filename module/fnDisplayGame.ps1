<# This Script controls the DisplayState of the game and works in tandem with fnGameLoop
to accurately project the game state

{Write-Host "";}

    #_$_^
    # = Main State Index (e.g Main Menu)
    $ = Sub State Categorization (e.g Informational)
    ^ = Sub State Index (e.g Error, Help)

Common States: 
    #_0_0 - Invalid Input Error
    #_0_1 - Help Message
    #_-1 - Game Termination
#>

function fnDisplayGame{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [String]$DisplayResult = 0
    )
    $fnSimpleElement = {
        param(
            [Parameter(Mandatory=$True,Position=0)]
            [String]$Element,
            [Parameter(Mandatory=$False,Position=1)]
            [String]$BackgroundColor = "Black",
            [Parameter(Mandatory=$False,Position=2)]
            [String]$ForegroundColor = "White"
            )
        $Elements = @{
            BorderTop = "╔~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╗"
            BorderBottom = "╚~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╝"
            BorderContinuation = "╠~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╣"
            EmptySpace = "║                                                                              ║"
            InnerBoxTop  = "║┌────────────────────────────────────────────────────────────────────────────┐║"
            InnerBoxBottom = "║└────────────────────────────────────────────────────────────────────────────┘║"
            InnerBoxMiddle = "║├────────────────────────────────────────────────────────────────────────────┤║"
            HelpBoxBannerTop = "║┌────────────────────────────┬──────────────────┬────────────────────────────┐║"
            HelpBoxBannerBottom = "║├────────────────────────────┴──────────────────┴────────────────────────────┤║"
            HelpBoxEmpty = "║│                                                                            │║"
            EmptyExitHelp = "║│                                                 exit - Saves and closes    │║"
            ErrorInput = "║     Error: Invalid Input! Type 'help' for valid commands at this field.      ║"
            InnerBorderTop = "║   )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )  ║"
            InnerBorderBottom = "║  (  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(   ║"
            TheodoraLineOne = "║   )\  ) ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  )\  )  ║"
            TheodoraLineTwo = "║  (  \(  ┃      _______ _                    _                      ┃ (  \(   ║"
            TheodoraLineThree = "║   )\  ) ┃     |__   __| |                  | |                     ┃  )\  )  ║"
            TheodoraLineFour = "║  (  \(  ┃        | |  | |__   ___  ___   __| | ___  _ __ __ _      ┃ (  \(   ║"
            TheodoraLineFive = "║   )\  ) ┃        | |  | '_ \ / _ \/ _ \ / _' |/ _ \| '__/ _' |     ┃  )\  )  ║"
            TheodoraLineSix = "║  (  \(  ┃        | |  | | | |  __/ (_) | (_| | (_) | | | (_| |     ┃ (  \(   ║"
            TheodoraLineSeven = "║   )\  ) ┃        |_|  |_| |_|\___|\___/ \__,_|\___/|_|  \__,_|     ┃  )\  )  ║"
            TheodoraLineEight = "║  (  \(  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ (  \(   ║"
            InnerBoxSegmentedTop = "║  ┌────────────┬──────────────┬──────────────────────┬─────────────────────┐  ║"
            InnerBoxSegmentedBottom = "║  └────────────┴──────────────┴──────────────────────┴─────────────────────┘  ║"
            InnerBoxSegmentedSplash = "║  │ By The Fox │ Version: 0.0 │ BuildDate: 5-24-2026 │ Pre-Release         │  ║"
            InnerBoxMiddleStart = "║│                           <Enter Start to Begin>                           │║"
            HelpBoxBannerSplash = "║│         Menu Input         │<~Splash Sc Help~>│       Generic Inputs       │║"
            SplashScreenHelpOne = "║│ start - Start the game                          help - Displays this       │║"
            MenuOne = "║│ 1. New Game                                                                │║"
            MenuTwo = "║│ 2. Load Game                                                               │║"
            MenuThree = "║│ 3. Settings                                                                │║"
            MenuFour = "║│ 4. Help                                                                    │║"
            DisclaimerOne = "║               IMPORTANT: DO NOT RESIZE THE GAME WINDOW AT ALL!               ║"
            DisclaimerTwo = "║            THE GAME WILL RESIZE THE CONSOLE HOST WINDOW AS NEEDED            ║"
            DisclaimerThree = "║    RESIZING THE WINDOW MANUALLY OR ATTEMPTING TO FULLSCREEN WILL BREAK IT    ║"
            SmallTheodoraOne = "║│                  _____ _  _ ___ ___  ___   ___  ___    _                   │║"
            SmallTheodoraTwo = "║│                 |_   _| || | __/ _ \|   \ / _ \| _ \  /_\                  │║"
            SmallTheodoraThree = "║│                   | | | __ | _| (_) | |) | (_) |   / / _ \                 │║"
            SmallTheodoraFour = "║│                   |_| |_||_|___\___/|___/ \___/|_|_\/_/ \_\                │║"
            HelpBoxBannerMain = "║│         Menu Input         │<~Main Menu Help~>│       Generic Inputs       │║"
            MainMenuHelpOne = "║│ Numeric 1 - Starts a new game                   help - Displays this       │║"
            MainMenuHelpTwo = "║│         2 - Load or continue                    exit - Saves and closes    │║"
            MainMenuHelpThree = "║│         3 - Configure options                                              │║"
            MainMenuHelpFour = "║│         4 - Displays this                                                  │║"
        }
        $WriteElement = {
            Write-Host $Elements.$Element -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor;
        }
        &$WriteElement
    }
    $fnComplexElement = {
        param(
            [Parameter(Mandatory=$True,Position=0)]
            [String]$Element
        )
        $ComplexElements = @{
            InvalidInput = @(BorderTop; ErrorInput; BorderBottom)
        }
        $WriteComplexElement = {
            $ComplexElements.$Element | Foreach {
                &$WriteElement
            } 
        }

    }

    $InvalidInput = {
        &$fnSimpleElement BorderTop
        &$fnSimpleElement ErrorInput
        &$fnSimpleElement BorderBottom
    }

    $SplashScreen = {
        $SplashBorder = {
            &$fnSimpleElement InnerBorderTop
            &$fnSimpleElement InnerBorderBottom
    }
        $TheodoraSplash = {
            &$fnSimpleElement TheodoraLineOne
            &$fnSimpleElement TheodoraLineTwo
            &$fnSimpleElement TheodoraLineThree
            &$fnSimpleElement TheodoraLineFour
            &$fnSimpleElement TheodoraLineFive
            &$fnSimpleElement TheodoraLineSix
            &$fnSimpleElement TheodoraLineSeven
            &$fnSimpleElement TheodoraLineEight
    }
        $SplashBox = {
            &$fnSimpleElement InnerBoxSegmentedTop
            &$fnSimpleElement InnerBoxSegmentedSplash
            &$fnSimpleElement InnerBoxSegmentedBottom
    }
        $StartBox = {
            &$fnSimpleElement InnerBoxTop
            &$fnSimpleElement InnerBoxMiddleStart
            &$fnSimpleElement InnerBoxBottom
    }
        Clear-Host;
        &$fnSimpleElement BorderTop
        &$fnSimpleElement EmptySpace
        &$SplashBorder
        &$TheodoraSplash
        &$SplashBorder
        &$SplashBox
        &$fnSimpleElement EmptySpace
        &$fnSimpleElement BorderContinuation
        &$StartBox
        &$fnSimpleElement BorderBottom
    }

    $SplashScreenHelp = {
        &$fnSimpleElement BorderTop
        &$fnSimpleElement HelpBoxBannerTop
        &$fnSimpleElement HelpBoxBannerSplash
        &$fnSimpleElement HelpBoxBannerBottom
        &$fnSimpleElement SplashScreenHelpOne
        &$fnSimpleElement EmptyExitHelp
        &$fnSimpleElement HelpBoxEmpty
        &$fnSimpleElement InnerBoxBottom
        &$fnSimpleElement BorderBottom
    }

    $MainMenu = {
        $Menu = {
                &$fnSimpleElement BorderTop
                &$fnSimpleElement InnerBoxTop
                &$fnSimpleElement MenuOne
                &$fnSimpleElement InnerBoxMiddle
                &$fnSimpleElement MenuTwo
                &$fnSimpleElement InnerBoxMiddle
                &$fnSimpleElement MenuThree
                &$fnSimpleElement InnerBoxMiddle
                &$fnSimpleElement MenuFour
                &$fnSimpleElement InnerBoxBottom
                &$fnSimpleElement BorderContinuation
            }
        $Disclaimer = {
                &$fnSimpleElement DisclaimerOne
                &$fnSimpleElement DisclaimerTwo
                &$fnSimpleElement DisclaimerThree
                &$fnSimpleElement BorderContinuation
            }
        $SmallTheodora = {
                &$fnSimpleElement InnerBoxTop
                &$fnSimpleElement SmallTheodoraOne
                &$fnSimpleElement SmallTheodoraTwo
                &$fnSimpleElement SmallTheodoraThree
                &$fnSimpleElement SmallTheodoraFour
                &$fnSimpleElement InnerBoxBottom
                &$fnSimpleElement BorderBottom
            }
        Clear-Host;
        &$Menu
        &$Disclaimer
        &$SmallTheodora
    }
    $MainMenuHelp = {
        &$fnSimpleElement BorderTop
        &$fnSimpleElement HelpBoxBannerTop
        &$fnSimpleElement HelpBoxBannerMain
        &$fnSimpleElement HelpBoxBannerBottom
        &$fnSimpleElement MainMenuHelpOne
        &$fnSimpleElement MainMenuHelpTwo
        &$fnSimpleElement MainMenuHelpThree
        &$fnSimpleElement MainMenuHelpFour
        &$fnSimpleElement HelpBoxEmpty
        &$fnSimpleElement InnerBoxBottom
        &$fnSimpleElement BorderBottom
    }

    if($DisplayResult -eq 0){
        fnSetConsoleWinSize -Width 80 -Height 24
        fnSetConsoleWinColor -Background Black -Foreground White
        &$SplashScreen
    }
    if($DisplayResult -eq "0_0_0"){
        fnSetConsoleWinSize -Width 80 -Height 27
        &$SplashScreen
        &$InvalidInput
    }
    if($DisplayResult -eq "0_0_1"){
        fnSetConsoleWinSize -Width 80 -Height 33
        fnSetConsoleWinColor -Background Black -Foreground White
        &$SplashScreen
        &$SplashScreenHelp
    }
    if($DisplayResult -eq 1){
        fnSetConsoleWinSize -Width 80 -Height 23
        &$MainMenu
    }
    if($DisplayResult -eq "1_0_0"){
        fnSetConsoleWinSize -Width 80 -Height 26
        &$MainMenu
        &$InvalidInput
    }
    if($DisplayResult -eq "1_0_1"){
        fnSetConsoleWinSize -Width 80 -Height 34
        &$MainMenu
        &$MainMenuHelp
    }
}
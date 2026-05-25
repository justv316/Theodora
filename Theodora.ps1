<#
.SYNOPSIS
A text based game created by Vanessa

.DESCRIPTION
You will play as a member of Empress Theodora Louise's inner circle
You are tasked with finding any evidence that points to the discovery of this worlds 'Rune of Life'

.NOTES
The game ends when the player reaches an ending, or perishes.

#>

# GLOBAL DEFINTIONS
# CALLABLE FUNCTIONS : Save-Game

#Requires -PSEdition Desktop
#Requires -Version 5.0

function fnSetConsoleWinSize{
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        [int]$Height = 40,
        [Parameter(Mandatory=$False,Position=1)]
        [int]$Width = 120
    )
    #Airlifted from https://ss64.com/ps/syntax-consolesize.html - Thanks m8
    $Console = $host.ui.RawUI
    $ConBuffer = $Console.BufferSize
    $ConSize = $Console.WindowSize
    $CurrWidth = $ConSize.Width
    $CurrHeight = $ConSize.Height
    if ($Height -gt $host.UI.RawUI.MaxPhysicalWindowSize.Height) {
        $Height = $host.UI.RawUI.MaxPhysicalWindowSize.Height
    }

    if ($Width -gt $host.UI.RawUI.MaxPhysicalWindowSize.Width) {
        $Width = $host.UI.RawUI.MaxPhysicalWindowSize.Width
    }
    If ($ConBuffer.Width -gt $Width ) {
        $currWidth = $Width
    }
    If ($ConBuffer.Height -gt $Height ) {
        $currHeight = $Height
    }
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($currWidth,$currHeight)
    $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.size($Width,2000)
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($Width,$Height)
}
function fnSetConsoleWinColor{
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        $Background = "Black",
        [Parameter(Mandatory=$False,Position=1)]
        $Foreground = "White"
    )
    $host.UI.RawUI.ForegroundColor = $Foreground
    $host.UI.RawUI.BackgroundColor = $Background
    cls
}
function fnConsoleInit{
    &fnSetConsoleWinSize -Width 80 -Height 24
    &fnSetConsoleWinColor
}
function fnDisplayGame{
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
        &$SplashScreen
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
function fnDisplayIndex{
    param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$Index = 0
    )
    if($Index -eq 0){
        fnDisplayGame 0
    }
    elseif($Index -eq 1){
        fnDisplayGame 1
    }
    elseif($Index -eq "1_0"){
        fnDisplayGame 1_0
    }
}
function fnGameLoop{
    param(
        [Parameter(Mandatory=$false,Position=0)]
        [string]$State = 0
    )
        if($State -eq 0){
            &fnDisplayIndex 0
            
            $ValidInput = @("start")
            $In = Read-Host ":"

            if($ValidInput -Contains $In){
                if($In -eq "start"){
                    &fnGameLoop 1
                }
                else{
                    &fnDisplayIndex 0
                }
            }
            else{
                &fnGameLoop 0
            }
        }
        elseif($State -eq 1){
            &fnDisplayIndex 1
            $In = Read-Host ":"
            if($In -eq "1"){
                &fnGameLoop 1_1
            }
            elseif($In -eq "2"){
                &fnGameLoop 1_2
            }
            elseif($In -eq "3"){
                &fnGameLoop 1_3
            }
            elseif($In -eq "4"){
                &fnGameLoop 1_4
            }
            else{
                &fnGameLoop 1_0
            }
        }
        elseif($State -eq "1_0"){
            &fnDisplayIndex 1_0
            $In = Read-Host ":"
            if($In -eq "1"){
                &fnGameLoop 1_1
            }
            elseif($In -eq "2"){
                &fnGameLoop 1_2
            }
            elseif($In -eq "3"){
                &fnGameLoop 1_3
            }
            elseif($In -eq "4"){
                &fnGameLoop 1_4
            }
            else{
                &fnGameLoop 1_0
            }
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
function fnStartGame{
    fnConsoleInit
    fnGameLoop 0
}
function Save-Game{
    $SavArr = @()
    $Slot = 0
    $ExportData = @(
        $Player.Data)
    $Savs = gci .\sav\*.xlsx
    $fnOverWriteSave = {
        Remove-Item $SavArr[$Slot-1].Path -force
        &$fnWriteSave
    }
    $fnWriteSave = {
        if($Slot -ge 1){
            $Date = (Get-Date).ToString("MM-dd-yy")
            $Time = (Get-Date).ToString("hh-mm-ss")
            $SaveName = $("$Slot"+" - "+"Theodora"+" - "+$Date+" - "+$Time+".xlsx")
            $SavePath = ".\sav\$SaveName"
            $ExportData | Export-Excel -path "$SavePath"
        }
    }
    $fnManualSaveInput = {
        if($SavArr.Count -eq 3){
            CLS
            $SavArr | FL
            $Slot = Read-Host "Save slots full, please choose a slot to overwrite. [1, 2, 3]"
            $Slot = $Slot -as [int]
            if($Slot -eq 1 -or $Slot -eq 2 -or $Slot -eq 3){
                &$fnOverWriteSave
            }
            else{
                Write-Host "Invalid Input."
                .$fnManualSaveInput
            }
        }
        elseif($SavArr.Count -lt 3){
            CLS
            $SavArr | FL
            $Slot = Read-Host "Select save slot, choose an empty slot or a slot to overwrite [1, 2, 3]"
            $Slot = $Slot -as [int]
            if(Test-Path $SavArr[$Slot-1].Path){
                &$fnOverWriteSave
            }
            if($Slot -eq 1 -or $Slot -eq 2 -or $Slot -eq 3){
                &$fnWriteSave
            }
            else{
                Write-Host "Invalid Input."
                .$fnManualSaveInput
            }
        }
    }
    $fnNewSave = {
        CLS
        $SaveVerify = Read-Host "No Save Data Found: Create it? [Y/N]"
        if($SaveVerify -eq "Y"){
            $Slot = 1
            &$fnWriteSave
        }
        elseif($SaveVerify -eq "N"){
            Read-Host "The game cannot proceed without Save Data."
            break
        }
        else{
            Write-Host "Invalid Input"
            .$fnNewSave
        }
    }
    $fnBuildSavArr = {
        $Savs | Foreach{
            $SavObject = [PSCustomObject]@{
            Slot = 1+$Slot++
            Name = $_.Name
            Path = $_.FullName
            }
            $SavArr += $SavObject
        }
        if($SavArr.Count -gt 0){
            &$fnManualSaveInput
        }
        elseif($SavArr.Count -eq 0){
            &$fnNewSave
        }
    }
    &$fnBuildSavArr
}

fnStartGame
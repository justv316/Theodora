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
    &fnSetConsoleWinSize -Width 80 -Height 25
    &fnSetConsoleWinColor
}
function fnDisplayGame{
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [int]$DisplayResult = 0
    )
    $TopBorder = {Write-Host "╔~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╗";}
    $BottomBorder = {Write-Host "╚~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╝";}
    $BottomBorderContinuation = {Write-Host "╠~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~══════~╣";}
    $EmptySpace = {Write-Host "║                                                                              ║";}
    $InnerBorderTop = {Write-Host "║   )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )\  )  ║";}
    $InnerBorderBottom = {Write-Host "║  (  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(  \(   ║";}
    $InnerBorderTopEmpty = {Write-Host "║   )\  )                                                               )\  )  ║";}
    $InnerBorderBottomEmpty = {Write-Host "║  (  \(                                                               (  \(   ║";}
    $InnerBorderVersion = {Write-Host "║   )\  )              Ver: 0.0 PreRelease                              )\  )  ║";}
    $TheodoraLineOne = {Write-Host "║  (  \(     * *  ┌───────────────────────────────────────────┐  * *   (  \(   ║";}
    $TheodoraLineTwo = {Write-Host "║   )\  )   (•*•) | _____ _  _ ___ ___  ___   ___  ___    _   | (•*•)   )\  )  ║";}
    $TheodoraLineThree = {Write-Host "║  (  \(     * *  ||_   _| || | __/ _ \|   \ / _ \| _ \  /_\  |  * *   (  \(   ║";}
    $TheodoraLineFour = {Write-Host "║   )\  )    * *  |  | | | __ | _| (_) | |) | (_) |   / / _ \ |  * *    )\  )  ║";}
    $TheodoraLineFive = {Write-Host "║  (  \(    (•*•) |  |_| |_||_|___\___/|___/ \___/|_|_\/_/ \_\| (•*•)  (  \(   ║";}
    $TheodoraLineSix = {Write-Host "║   )\  )    * *  └───────────────────────────────────────────┘  * *    )\  )  ║";}
    $TheodoraLineSeven = {Write-Host "║  (  \(               By: The Fox <~══════~> When: May 2026           (  \(   ║";}
    $StartBoxOne = {Write-Host "║┌────────────────────────────────────────────────────────────────────────────┐║";}
    $StartBoxTwo = {Write-Host "║│                         <Press Enter to Continue>                          │║";}
    $StartBoxThree = {Write-Host "║└────────────────────────────────────────────────────────────────────────────┘║";}

    $InnerBorder = {
        &$InnerBorderTop
        &$InnerBorderBottom
    }
    $InnerBorderEmpty = {
        &$InnerBorderTopEmpty
        &$InnerBorderBottomEmpty
    }
    $TheodoraDisplay = {
     &$TheodoraLineOne
     &$TheodoraLineTwo
     &$TheodoraLineThree
     &$TheodoraLineFour
     &$TheodoraLineFive
     &$TheodoraLineSix
     &$TheodoraLineSeven
    }

    $StartBox = {
       &$StartBoxOne
       &$StartBoxTwo
       &$StartBoxThree
    }

    if($DisplayResult -eq 0){
        Clear-Host;
        &$TopBorder
        &$EmptySpace
        &$InnerBorder
        &$InnerBorderEmpty
        &$InnerBorderVersion
        &$TheodoraDisplay
        &$InnerBorderEmpty
        &$InnerBorder
        &$EmptySpace
        &$BottomBorderContinuation
        &$StartBox
        &$BottomBorder
    }
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
function fnSetValidInput{
    $GenericInput = @("help")
}
function fnGameLoop{
    while($State -ne "" -or $State -ne $null){
        if($State -eq 0){
            $InputLoop = {
                fnDisplayGame 0
                $Input = Read-Host ":3"
            }
            if($Input -eq ""){
                $State = 1
            }
            else{
                .$InputLoop
            }
        }
        if($State -eq 1){
            "State is 1 :)"
        }
    }
}
function fnStartGame{
    fnConsoleInit
    $State = 0
    fnGameLoop
}

fnStartGame

<#function New_Player{
    cls
    Read-Host 
    
    #Import Default Player Object
    $PlayerImport = Import-Excel -Path .\dat\TheodoraDB.xlsx -WorksheetName 'Player'
    $Player_Data = [PSCustomObject]@{
        #Elements that impact the gameplay
        Index = $PlayerImport.Index
        CurLC = $PlayerImport.CurLC
        CurLVL = $PlayerImport.CurLVL
        CurEXP = $PlayerImport.CurEXP
        CurHP = $PlayerImport.CurHP
    }
    $Player_Bio = [PSCustomObject]@{
        #Elements that are biographical
        FirstName = $PlayerImport.FirstName
        LastName = $PlayerImport.LastName
        FullName = $PlayerImport.FullName
        Age = $PlayerImport.Age
        Height = $PlayerImport.Height
        Weight = $PlayerImport.Weight
    }
    $Player = [PSCustomObject]@{
        Data = $Player_Data
        Bio = $Player_Bio
    }
function Load-Game{
    
}

function Import_Locations{
    $LCs = @()
    $LCImport = Import-Excel .\dat\TheodoraDB.xlsx -WorksheetName 'Locations'
    $LCImport | Foreach {
        $LC = [PSCustomObject]@{
            Index = $_.Index
            Name = $_.Name
            Description = $_.Description
            ValidDirections = $_.ValidDirections -Split(" ")
            InvalidDirection = $_.InvalidDirection -Split(" ")
            ValidActions = $_.ValidActions -Split(" ")
        }
        $LC | Foreach {
            $LCs += $LC
        }
    }
}
}#>
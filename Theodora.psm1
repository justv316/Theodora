<#
.SYNOPSIS
A text based game created by Vanessa

.DESCRIPTION
You will play as a member of Empress Theodora Louise's inner circle
You are tasked with finding any evidence that points to the discovery of this worlds 'Rune of Life'

.NOTES
The game ends when the player reaches an ending, or perishes.



# GLOBAL DEFINTIONS
# CALLABLE FUNCTIONS : Save-Game

#>

# Dot-Source Module Scripts

foreach($Directory in @('Module')){
    Get-ChildItem "$PSScriptRoot\$Directory\*.ps1" | ForEach-Object { . $_.FullName }
}


#Requires -PSEdition Desktop
#Requires -Version 5.0
Clear-Host
Write-Host "Setup Complete - Run 'Play-Theodora' to launch." -BackgroundColor DarkGreen -ForegroundColor White


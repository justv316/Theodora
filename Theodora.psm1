<#
.SYNOPSIS
A text based game created by The Fox

.DESCRIPTION
You will play as a member of Empress Theodora Louise's inner circle
You are tasked with finding any evidence that points to the discovery of this worlds 'Rune of Life'

.NOTES
The game ends when the player reaches an ending, or perishes.
#>

#Requires -Version 7.5
#Requires -Modules argparser
# Dot-Source Module Scripts
foreach($Directory in @('Module')){
    Get-ChildItem "$PSScriptRoot\$Directory\*.ps1" | ForEach-Object { . $_.FullName }
}
if($Null -eq $States){
    fnXML "States"
}

Clear-Host
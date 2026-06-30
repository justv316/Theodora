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


#Requires -Version 7.5
#Requires -Modules argparser
Clear-Host
fnwriteobject -InputString "Setup Complete! Run 'Start-Theodora' to launch." -ObjectFormatting "--InputType=String --EnforcedMaxLength=120 --MinimumPaddingLength=4 --BorderType=Double" -BuildFormatting "--ObjectType=Boxed --Justification=Center" -ColorFormatting "--BorderForegroundColor=Magenta --BorderBackgroundColor=DarkBlue --TextForegroundColor=Red --IgnoreBorderPadding"


Function fnBuildSavArr{
    [CmdletBinding()]
    param()
    $Savs = Get-ChildItem $PSScriptRoot\dat\sav\*.csv
    $Savs | ForEach-Object{
        $SavObject = [PSCustomObject]@{
        Slot = 1+$Slot++
        Name = $_.Name
        Path = $_.FullName
        }
        $SavArr += $SavObject
    }
    if($SavArr.Count -eq 0 -or $SavArr -eq "" -or $Null -eq $SavArr){
        fnGameLoop 2_1_0
    }
    elseif($SavArr.Count -gt 0 -and $SavArr.Count -lt 3){
        fnGameLoop 2_1_1
    }
    elseif($SavArr.Count -eq 3){
        fnGameLoop 2_1_2
    }
}
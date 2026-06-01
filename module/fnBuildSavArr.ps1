Function fnBuildSavArr{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [String]$Verb
    )
    $SavArr = @()
    $Slot = 0
    $Savs = Get-ChildItem $PSScriptRoot\dat\sav\*.csv
    $Savs | ForEach-Object{
        $SavObject = [PSCustomObject]@{
        Slot = 1+$Slot++
        Name = $_.Name
        Path = $_.FullName
        }
        $SavArr += $SavObject
    }

    if($Verb -eq "Save"){
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

    if($Verb -eq "Load"){
        if($SavArr.Count -gt 0){
            fnGameLoop 2_2_0
        }
    }

    if($Verb -eq "List"){
        Write-Host "List!"
    }
}
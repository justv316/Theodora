function fnSaveGame{
    $SavArr = @()
    $Slot = 0
    $ExportData = @($CharacterObject)
    $Savs = Get-ChildItem .\dat\sav\*.csv
    $fnOverWriteSave = {
        Remove-Item $SavArr[$Slot-1].Path -force
        &$fnWriteSave
    }
    $fnWriteSave = {
        if($Slot -ge 1){
            $Date = (Get-Date).ToString("MM-dd-yy")
            $Time = (Get-Date).ToString("hh-mm-ss")
            $SaveName = $("$Slot"+" - "+"Theodora"+" - "+$Date+" - "+$Time+".csv")
            $SavePath = ".\dat\sav\$SaveName"
            $ExportData | Export-CSV -path "$SavePath"
        }
    }
    $fnManualSaveInput = {
        if($SavArr.Count -eq 3){
            Clear-Host
            $SavArr | Format-List
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
            Clear-Host
            $SavArr | Format-List
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
        Clear-Host
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
        $Savs | ForEach-Object{
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
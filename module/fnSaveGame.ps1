function fnSaveGame{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [String]$Verb
    )

    $fnWriteSave = {
        $Date = (Get-Date).ToString("MM-dd-yy")
        $Time = (Get-Date).ToString("hh-mm-ss")
        $SaveName = $("$Slot"+" - "+"Theodora"+" - "+$Date+" - "+$Time+".csv")
        $SavePath = ".\dat\sav\$SaveName"
        $ExportData | Export-CSV -path "$SavePath"
    }
    
    if($Verb -eq "New"){
        &$fnWriteSave
        &fnGameLoop 3
    }
    

}
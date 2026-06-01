Function fnWriteSave{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [String]$SaveSlot
    )
        $Date = (Get-Date).ToString("MM-dd-yy")
        $Time = (Get-Date).ToString("hh-mm-ss")
        $SaveName = $("$SaveSlot"+" - "+"Theodora"+" - "+$Date+" - "+$Time+".csv")
        $SavePath = "$PSScriptRoot\dat\sav\$SaveName"
        $ExportData | Export-CSV -path "$SavePath"
        FnGameLoop 3
}
    
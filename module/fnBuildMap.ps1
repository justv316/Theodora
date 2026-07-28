#using module E:\Documents\Github\PSGame\Theodora\Theodora.psm1

function fnBuildMap{
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]$MapName
    )
    begin{
        if($Null -eq $MapGrids){
            $Script:MapGrids = @()
        }
    }
    process{
        $MapGrid = [Map]::New($Mapname)
        $MapGrid.FillFromTemplate($MapName)
        $MapGrid.UpdatePixels()
    }
    end{
        $Script:MapGrids += $MapGrid
    }
}
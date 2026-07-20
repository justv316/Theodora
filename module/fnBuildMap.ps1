using module E:\Documents\Github\PSGame\Theodora\Theodora.psm1

function fnBuildMap{
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]$MapName
    )
    begin{
        if($Null -eq $MapGrids){
            $Global:MapGrids = @()
        }
    }
    process{
        $Global:MapGrid = [Map]::New($Mapname)
    }
    end{
        $Global:MapGrids += $MapGrid
        $Global:MapGrids
    }
}
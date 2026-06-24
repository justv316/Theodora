function fnXML{
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [String] $XML
    )
    begin{
        $Fonts = @("Large", "Standard", "Graceful")
        if($Fonts -Contains $XML){
            if(-not(Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name $XML)){
                New-Variable -Name "$XML" -Scope Script -Value @{} -ErrorAction SilentlyContinue
            }
        }
        if($XML -eq 'Characters' -and (-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters))){
            $Script:Characters = @{}
        }
        if($XML -eq 'Boxes' -and (-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Boxes))){
            $Script:Boxes = @{}
        }
        
        $File = "E:\Documents\GitHub\PSGame\Theodora\module\xml\$($XML).xml"
        $FileXML = [XML] (Get-Content $File -ErrorAction SilentlyContinue)
    }
    process{
        if($Fonts -Contains $XML){
            $FileXML.Chars.Char | Foreach-Object {
                if($_.Name -ne 'template'){
                    $(Get-Variable -Name $XML -ValueOnly)["$($_.Name)"] = New-Object PSObject -Property @{
                        'ASCII' = $_.Data
                        'Width' = $_.Width
                        'Lines' = $_.lines
                        'Font' = $_.Font
                    }
                }
            }
        }
        elseif($XML -eq "Characters"){
            $FileXML.types.type | ForEach-Object {
                [String]$BName = $_.Name
                $Characters[$BName] = @{}
                $_.ChildNodes | Foreach-Object{
                    [String]$Name = $_.Name
                    [String]$Value = $_.Value
                    $Characters[$BName][$Name] = $Value
                }
            }
        }
        elseif($XML -eq "Boxes"){
            $BoxTypes = @("Single", "Double")
            $BorderTypes = @("Vertical", "Horizontal", "TopLeftCorner", "BottomLeftCorner", "TopRightCorner", "BottomLeftCorner", "MiddleLeft", "MiddleRight")
            $BoxTypes | Foreach-Object {
                $Type = [String]$_
                $Boxes[$Type] = @{}
                Foreach($Border in $BorderTypes){
                    $Boxes[$Type][$Border] = $Characters[$Type][$Border]
                }
            }
        }
    }
}


       
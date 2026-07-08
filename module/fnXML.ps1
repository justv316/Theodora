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
            $Script:CharacterSets = @{
                "Vertical" = @()
                "Horizontal" = @()
                "TopLeftCorner" = @()
                "TopRightCorner" = @()
                "BottomLeftCorner" = @()
                "BottomRightCorner" = @()
                "MiddleLeft" = @()
                "MiddleRight" = @()
                "MiddleTop" = @()
                "MiddleBottom" = @()
                "CenterJunction" = @()
            }
        }
        if($XML -eq 'Boxes' -and (-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Boxes))){
            $Script:Boxes = @{}
        }
        if($XML -eq 'States' -and (-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name States))){
            $Script:States = @{}
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
                [String]$TypeName = $_.Name
                $Characters[$TypeName] = @{}
                $_.ChildNodes | Foreach-Object{
                    [String]$Name = $_.Name
                    [String]$Value = $_.Value
                    If($TypeName -ne "None"){
                        $CharacterSets[$Name] += $Value
                    }
                    $Characters[$TypeName][$Name] = $Value
                }
            }
        }
        elseif($XML -eq "Boxes"){
            $BoxTypes = @("Single", "Double", "DoubleSingle", "SingleDouble", "SingleBold", "SingleHorizontalBold", "SingleVerticalBold", "DoubleSingleDashed","None")
            $BorderTypes = @("Vertical", "Horizontal", "TopLeftCorner", "BottomLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner", "MiddleLeft", "MiddleRight", "CenterJunction")
            $BoxTypes | Foreach-Object {
                $Type = [String]$_
                $Boxes[$Type] = @{}
                Foreach($Border in $BorderTypes){
                    $Boxes[$Type][$Border] = $Characters[$Type][$Border]
                }
            }
        }
        elseif($XML -eq "States"){
            $FileXML.States.StateGroup | Foreach-Object {
                [String]$GroupName = $_.Name
                $States[$GroupName] = [PSCustomObject]@{}
                $_.ChildNodes | Foreach-Object{
                    [String]$Name = $_.Name
                    [String]$Value = $_.Value
                    $States[$GroupName] | Add-Member NoteProperty -Name $Name -Value $Value -Force
                }
            }
            foreach($State in $States.Keys){
                $BuildFormatting = $States[$State].BuildFormatting
                $GridFormatting = $States[$State].GridFormatting
                $ColorFormatting = $States[$State].ColorFormatting
                $ManualFormatting = $States[$State].ManualFormatting
                $StateGrid = fnAssembleObject -BuildFormatting $BuildFormatting -GridFormatting $GridFormatting -ColorFormatting $ColorFormatting -ManualFormatting $ManualFormatting
                $States["$State"] | Add-Member NoteProperty -Name "StateGrid" -Value $StateGrid -Force
            }
        }
    }
}
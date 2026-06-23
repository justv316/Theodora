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
            $Script:Boxes = @{
                "Unspecified" = @{
                    "BorderLines" = 0
                    "OuterBorderLines" = 0
                }
                "SingleBox" = @{
                    "BorderLines" = 2
                    "OuterBorderLines" = 1
                    "OuterBorder" = $Characters.SingleVertical
                    "OuterHorizontalBorder" = $Characters.SingleHorizontal
                    "OuterTopBorderLC" = $Characters.SingleTopLeftCorner
                    "OuterTopBorderRC" = $Characters.SingleTopRightCorner
                    "OuterBottomBorderLC" = $Characters.SingleBottomLeftCorner
                    "OuterBottomBorderRC" = $Characters.SingleBottomRightCorner
                    "LeftBorder" = $Characters.SingleVertical
                    "RightBorder" = $Characters.SingleVertical
                }
                "DoubleBox" = @{
                    "BorderLines" = 2
                    "OuterBorderLines" = 1
                    "OuterBorder" = $Characters.DoubleVertical
                    "OuterHorizontalBorder" = $Characters.DoubleHorizontal
                    "OuterTopBorderLC" = $Characters.DoubleTopLeftCorner
                    "OuterTopBorderRC" = $Characters.DoubleTopRightCorner
                    "OuterBottomBorderLC" = $Characters.DoubleBottomLeftCorner
                    "OuterBottomBorderRC" = $Characters.DoubleBottomRightCorner
                    "LeftBorder" = $Characters.DoubleVertical
                    "RightBorder" = $Characters.DoubleVertical
                }
                "SingleDoubleBox" = @{
                    "BorderLines" = 4
                    "OuterBorderLines" = 2
                    "OuterBorder" = $Characters.DoubleVertical
                    "OuterHorizontalBorder" = $Characters.DoubleHorizontal
                    "OuterTopBorderLC" = $Characters.DoubleTopLeftCorner
                    "OuterTopBorderRC" = $Characters.DoubleTopRightCorner
                    "OuterBottomBorderLC" = $Characters.DoubleBottomLeftCorner
                    "OuterBottomBorderRC" = $Characters.DoubleBottomRightCorner
                    "InnerBorder" = $Characters.SingleVertical
                    "InnerHorizontalBorder" = $Characters.SingleHorizontal
                    "InnerTopBorderLC" = $Characters.SingleTopLeftCorner
                    "InnerTopBorderRC" = $Characters.SingleTopRightCorner
                    "InnerBottomBorderLC" = $Characters.SingleBottomLeftCorner
                    "InnerBottomBorderRC" = $Characters.SingleBottomRightCorner
                    "LeftBorder" = $Characters.DoubleVertical + $Characters.SingleVertical
                    "RightBorder" = $Characters.SingleVertical + $Characters.DoubleVertical
                }
            }
        }
        if($XML -ne "Boxes"){
            $File = "E:\Documents\GitHub\PSGame\Theodora\module\xml\$($XML).xml"
            $FileXML = [XML] (Get-Content $File)
        }
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
            $FileXML.Chars.Char | ForEach-Object {
                $Characters[$($_.Name)] = $_.Data
            }
        }
    }
}

 
       
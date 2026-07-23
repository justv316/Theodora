class Map{
    [String]$Name
    [Int]$Width = 36
    [Int]$Height = 36
    $Grid
    $Ninths
    Map([String]$Name){
        $this.Name = $Name
        $this.Width = 36
        $this.Height = 36
        # 36p x 36p
        $this.Grid = [System.Collections.SortedList]::new()
        # 12p x 12p x 9Ninths
        $this.Ninths = [System.Collections.SortedList]::new()
        # 3p x 3p x 9SubGrids
        foreach($LineNumber in 1..$This.Height){
            $this.Grid[$LineNumber] = @()
            foreach($ColumnNumber in 1..$this.Width){
                $Char = [Character]::New($ColumnNumber, $LineNumber, "Pixel", $Script:Characters.Map.Unrevealed)
                $this.Grid[$LineNumber] += $Char
            }
        }
        foreach($Y in 1..9){
            $This.Ninths[$Y] = [Ninths]::new($Y)
            foreach($X in 1..9){
                $This.Ninths[$Y].SubGrids[$X] = [SubGrids]::new($X)
            }
        }
        $PixelS = 1
        $PixelE = 12
        $LineS = 1
        $LineE = 12
        foreach($Y in 1..9){
            $RelativeLine = 1
            foreach($Line in $LineS..$LineE){
                $RelativeColumn = 1
                foreach($Pixel in $PixelS..$PixelE){
                    $ThisPixel = $This.Grid[$Line] | Where-Object{$_.ColumnNumber -eq $Pixel} | Select-Object
                    $ThisPixel.RelativeColumn = $RelativeColumn
                    $ThisPixel.RelativeLine = $RelativeLine
                    $ThisPixel.RelativePosition = @($RelativeColumn, $RelativeLine)
                    $This.Ninths[$Y].Pixels += $ThisPixel
                    $RelativeColumn = $RelativeColumn + 1
                }
                $RelativeLine = $RelativeLine + 1
            }
            if($Y -ne 3 -or $Y -ne 6){
                $PixelS = $PixelS + 12
                $PixelE = $PixelE + 12
            }
            if($Y -eq 3 -or $Y -eq 6){
                $PixelS = 1
                $PixelE = 12
                $LineS = $LineS + 12
                $LineE = $LineE + 12
            }
        }
        foreach($Ninth in 1..$This.Ninths.Count){
            $PixelS = 1
            $PixelE = 3
            $LineS = 1
            $LineE = 3
            foreach($Y in 1..9){
                foreach($Line in $LineS..$LineE){
                    foreach($Pixel in $PixelS..$PixelE){
                        $ThisPixel = $This.Ninths[$Ninth].Pixels | Where-Object{$_.RelativeColumn -eq $Pixel -and $_.RelativeLine -eq $Line} | Select-Object
                        $This.Ninths[$Ninth].SubGrids[$Y].Pixels += $ThisPixel
                    }
                }
                if($Ninth -ne 3 -or $Ninth -ne 6){
                    $PixelS = $PixelS + 3
                    $PixelE = $PixelE + 3
                }
                if($Ninth -eq 3 -or $Ninth -eq 6){
                    $PixelS = 1
                    $PixelE = 3
                    $LineS = $LineS + 3
                    $LineE = $LineE + 3
                }
            }
        }
    } # End Constructors
    # Methods
}

class Character{
    [Int]$ColumnNumber
    [Int]$LineNumber
    [Array]$AbsolutePosition
    [Int]$RelativeColumn
    [Int]$RelativeLine
    [Array]$RelativePosition
    [String]$Type
    [String]$Char
    [String]$ForegroundColor
    [String]$BackgroundColor
    [Bool]$Revealed
    Character([Int]$ColumnNumber, [Int]$LineNumber, [String]$Type, [String]$Char, [String]$ForegroundColor, [String]$BackgroundColor, [Bool]$Revealed){
        $this.ColumnNumber = $ColumnNumber
        $this.LineNumber = $LineNumber
        $this.Type = $Type
        $this.Char = $Char
        $this.ForegroundColor = $ForegroundColor
        $this.BackgroundColor = $BackgroundColor
        $this.Revealed = $Revealed
    }
    Character([Int]$ColumnNumber, [Int]$LineNumber, [String]$Type, [String]$Char){
        $this.ColumnNumber = $ColumnNumber
        $this.LineNumber = $LineNumber
        $this.Type = $Type
        $this.Char = $Char
        $this.AbsolutePosition = @($ColumnNumber,$LineNumber)
        $this.ForegroundColor = 'White'
        $this.BackgroundColor = 'Black'
        $this.Revealed = $False
    }
    [void] Reveal([String]$Char){
        $this.Revealed = $True
        $this.Char = $Char
    }
}


class Ninths{
    [Int]$Index
    [String]$CardinalLocation
    $SubGrids
    $Pixels
    Ninths([Int]$Index){
        $This.Index = $Index
        $This.SubGrids = [System.Collections.SortedList]::new()
        $This.Pixels = @()
    }
}
class SubGrids{
    [Int]$Index
    [Array]$AbsPos
    $Pixels
    SubGrids([Int]$Index){
        $This.Index = $Index
        $This.Pixels = @()
    }
}
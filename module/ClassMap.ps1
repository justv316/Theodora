class Map{
    [String]$Name
    [Int]$Width = 36
    [Int]$Height = 36
    $Grid
    $Ninths
    $SubGrids
    $PixelGroups
    Map([String]$Name){
        $this.Name = $Name
        $this.Width = 36
        $this.Height = 36
        # 36p x 36p
        $this.Grid = [System.Collections.SortedList]::new()
        # 12p x 12p x 9Ninths
        $this.Ninths = [System.Collections.SortedList]::new()
        # 8p x 8p x 9SubGrids
        $this.SubGrids = [System.Collections.SortedList]::new()
        # 4p x 4p x 4Pixelgroups
        $this.PixelGroups = [System.Collections.SortedList]::new()

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
                foreach($Z in 1..4){
                    $This.Ninths[$Y].SubGrids[$X].PixelGroups[$Z] = [PixelGroups]::new($Z)
                }
            }
        }
        $PixelS = 1
        $PixelE = 12
        $LineS = 1
        $LineE = 12
        foreach($Y in 1..9){
            foreach($Line in $LineS..$LineE){
                foreach($Pixel in $PixelS..$PixelE){
                    $This.Ninths[$Y].Pixels += $This.Grid[$Line] | Where-Object{$_.Index -eq $Pixel}
                }
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
    } # End Constructors
    # Methods
}

class Character{
    [Int]$Index
    [Int]$LineNumber
    [String]$Type
    [String]$Char
    [String]$ForegroundColor
    [String]$BackgroundColor
    [Bool]$Revealed
    [Int]$RelativePosition
    Character([Int]$Index, [Int]$LineNumber, [String]$Type, [String]$Char, [String]$ForegroundColor, [String]$BackgroundColor, [Bool]$Revealed){
        $this.Index = $Index
        $this.LineNumber = $LineNumber
        $this.Type = $Type
        $this.Char = $Char
        $this.ForegroundColor = $ForegroundColor
        $this.BackgroundColor = $BackgroundColor
        $this.Revealed = $Revealed
    }
    Character([Int]$Index, [Int]$LineNumber, [String]$Type, [String]$Char){
        $this.Index = $Index
        $this.LineNumber = $LineNumber
        $this.Type = $Type
        $this.Char = $Char
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
    $PixelGroups
    $Pixels
    SubGrids([Int]$Index){
        $This.Index = $Index
        $This.PixelGroups = [System.Collections.SortedList]::new()
        $This.Pixels = @()
    }

}
class PixelGroups{
    [Int]$Index
    [Array]$AbsPos
    $Pixels
    PixelGroups([Int]$Index){
        $This.Index = $Index
        $This.Pixels = @()
    }
}
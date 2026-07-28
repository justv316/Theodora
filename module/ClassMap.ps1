class Map{
    [String]$Name
    [Int]$Width = 27
    [Int]$Height = 27
    $Grid
    $Ninths
    Map([String]$Name){
        $this.Name = $Name
        $this.Width = 27
        $this.Height = 27
        # 27 x 27
        $this.Grid = [System.Collections.SortedList]::new()
        # 9 x 9 x 9
        $this.Ninths = [System.Collections.SortedList]::new()
        # 3 x 3 x 9SubGrids
        foreach($LineNumber in 1..$This.Height){
            $this.Grid[$LineNumber] = @()
            foreach($ColumnNumber in 1..$this.Width){
                $Char = [Character]::New($ColumnNumber, $LineNumber, "Pixel", "")
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
        $PixelE = 9
        $LineS = 1
        $LineE = 9
        foreach($Y in 1..9){
            $RelativeLine = 1
            foreach($Line in $LineS..$LineE){
                $RelativeColumn = 1
                foreach($Pixel in $PixelS..$PixelE){
                    $ThisPixel = $This.Grid[$Line] | Where-Object{$_.ColumnNumber -eq $Pixel} | Select-Object
                    $ThisPixel.RelativeColumn = $RelativeColumn
                    $ThisPixel.RelativeLine = $RelativeLine
                    $ThisPixel.RelativePosition = @($RelativeColumn, $RelativeLine)
                    $ThisPixel.RelativePosition = $ThisPixel.RelativePosition -as [String]
                    $This.Ninths[$Y].Pixels += $ThisPixel
                    $RelativeColumn = $RelativeColumn + 1
                }
                $RelativeLine = $RelativeLine + 1
            }
            if($Y -ne 3 -or $Y -ne 6){
                $PixelS = $PixelS + 9
                $PixelE = $PixelE + 9
            }
            if($Y -eq 3 -or $Y -eq 6){
                $PixelS = 1
                $PixelE = 9
                $LineS = $LineS + 9
                $LineE = $LineE + 9
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
                if($Y -ne 3 -or $Y -ne 6){
                    $PixelS = $PixelS + 3
                    $PixelE = $PixelE + 3
                }
                if($Y -eq 3 -or $Y -eq 6){
                    $PixelS = 1
                    $PixelE = 3
                    $LineS = $LineS + 3
                    $LineE = $LineE + 3
                }
            }
        }
    } # End Constructors
    # Methods
    [void] FillFromTemplate([String]$Template){
        foreach($Ninth in 1..$This.Ninths.Count){
            $This.Ninths[$Ninth].FillFromTemplate($Script:MapTemplates.$Template[$Ninth])
        }
    }
    [void] UpdatePixels(){
        $This.Grid = [System.Collections.SortedList]::new()
        Foreach($LineNumber in 1..$This.Height){
            $This.Grid[$LineNumber] = @()
        }
        foreach($Ninth in 1..$This.Ninths.Count){
            Foreach($SubGrid in 1..$This.Ninths[$Ninth].Subgrids.Count){
                foreach($Pixel in 0..($This.Ninths[$Ninth].Subgrids[$Subgrid].Pixels.Count-1)){
                    $ThisPixel = $This.Ninths[$Ninth].Subgrids[$Subgrid].Pixels[$Pixel]
                    $This.Grid[$ThisPixel.LineNumber] += $ThisPixel
                }
            }
        }
    }
    [void] Write(){
        foreach($Line in 1..$This.Grid.Count){
            Foreach($Pixel in 0..($This.Grid[$Line].Count-1)){
                $ThisPixel = $This.Grid[$Line][$Pixel]
                if($Null -eq $ThisPixel.ForegroundColor -or '' -eq $ThisPixel.ForegroundColor){
                    Set-ItemProperty $ThisPixel.ForegroundColor -Value 'White'
                }
                if($Null -eq $ThisPixel.BackgroundColor -or '' -eq $ThisPixel.BackgroundColor){
                    Set-ItemProperty $ThisPixel.BackgroundColor -Value 'Black'
                }
                if($ThisPixel.ColumnNumber -ne $This.Width){
                    Write-Host $ThisPixel.Char -ForegroundColor $ThisPixel.ForegroundColor -BackgroundColor $ThisPixel.BackgroundColor -NoNewline
                }
                elseif($ThisPixel.ColumnNumber -eq $This.Width){
                    Write-Host $ThisPixel.Char -ForegroundColor $ThisPixel.ForegroundColor -BackgroundColor $ThisPixel.BackgroundColor -NoNewline
                    Write-Host ''
                }
            }
        }
    }
}

class Ninths{
    [Int]$Index
    $SubGrids
    $Pixels
    $AppliedTemplate
    Ninths([Int]$Index){
        $This.Index = $Index
        $This.SubGrids = [System.Collections.SortedList]::new()
        $This.Pixels = @()
    }
    [void] FillFromTemplate([String]$Template){
        foreach($SubGrid in 1..$This.SubGrids.Count){
            $This.Subgrids[$SubGrid].FillFromTemplate($Script:NinthTemplates.$Template[$SubGrid])
        }
        $This.AppliedTemplate = $Template -as [String] 
    }
    [void] Write(){
        $Y = 1
        Foreach($Pixel in $This.pixels){
            if($Y -ne 9){
                Write-Host $Pixel.Char -NoNewline
                $Y = $Y + 1
            }
            else{
                Write-Host $Pixel.Char -NoNewline
                Write-Host ''
                $Y = 1
            }
        }
    }
}
class SubGrids{
    [Int]$Index
    $Pixels
    $AppliedTemplate
    SubGrids([Int]$Index){
        $This.Index = $Index
        $This.Pixels = @()
    }
    [void] FillFromTemplate([String]$Template){
        $ThisSprite = $Script:Sprites.$Template | Select-Object
        $SpriteArr = $ThisSprite.Data -Split ''
        $SpriteArr = $SpriteArr[1..9]
        $ReplaceHash = @{}
        $N = 1
        $SpriteArr | Foreach-Object{
            $ReplaceHash[$N] = $_
            $N = $N + 1
        }
        Foreach($Pixel in 1..9){
            $This.Pixels[$Pixel-1].Set($ReplaceHash[$Pixel])
        }
        $This.AppliedTemplate = $Template -as [String] 
    }
    [void] Write(){
        $Y = 1
        Foreach($Pixel in $This.pixels){
            if($Y -ne 3){
                Write-Host $Pixel.Char -NoNewline
                $Y = $Y + 1
            }
            else{
                Write-Host $Pixel.Char -NoNewline
                Write-Host ''
                $Y = 1
            }
        }
    }
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
        $this.AbsolutePosition = $this.AbsolutePosition -as [String]
        $this.ForegroundColor = 'White'
        $this.BackgroundColor = 'Black'
        $this.Revealed = $False
    }
    [void] Reveal([String]$Char){
        $this.Revealed = $True
        $this.Char = $Char
    }
    [void] Set([String]$Char){
        $this.Char = $Char
    }
}
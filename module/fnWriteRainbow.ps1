function fnWriteRainbow {
    [CmdletBinding()]
    param(
        [String] $Line,
        [Alias('Foreground')]
        [String] $ForegroundColor = '',
        [Alias('Background')]
        [String] $BackgroundColor = '',
        [Switch] $Segmented
    )
    begin{
        $Colors = @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow',
            'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')
    }
    process{
        [Char[]] $Line | ForEach-Object {
            if($ForegroundColor -and $ForegroundColor -eq 'rainbow') {
                if ($BackgroundColor -and $BackgroundColor -eq 'rainbow') {
                    Write-Host -ForegroundColor $Colors[(Get-Random -Min 0 -Max 16)] -BackgroundColor $Colors[(Get-Random -Min 0 -Max 16)] -NoNewLine $_
                }
                elseif ($BackgroundColor) {
                    Write-Host -ForegroundColor $Colors[(Get-Random -Min 0 -Max 16)] -BackgroundColor $BackgroundColor -NoNewLine $_
                }
                else{
                    Write-Host -ForegroundColor $Colors[(Get-Random -Min 0 -Max 16)] -NoNewLine $_
                }

            }
            else{
                if($ForegroundColor){
                    Write-Host -ForegroundColor $ForegroundColor -BackgroundColor $Colors[(Get-Random -Min 0 -Max 16)] -NoNewLine $_
                }
                else{
                    Write-Host -BackgroundgroundColor $Colors[(Get-Random -Min 0 -Max 16)] -NoNewLine $_
                }
            }
        }
        if(!($Segmented)){
            Write-Host ''
        }
    }
}
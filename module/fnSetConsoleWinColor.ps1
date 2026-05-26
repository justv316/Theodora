function fnSetConsoleWinColor{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        $Background = "Black",
        [Parameter(Mandatory=$False,Position=1)]
        $Foreground = "White"
    )
    $host.UI.RawUI.ForegroundColor = $Foreground
    $host.UI.RawUI.BackgroundColor = $Background
    cls
}
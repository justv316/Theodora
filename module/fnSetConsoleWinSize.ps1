function fnSetConsoleWinSize{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        [int]$Height = 40,
        [Parameter(Mandatory=$False,Position=1)]
        [int]$Width = 120
    )
    #Airlifted from https://ss64.com/ps/syntax-consolesize.html - Thanks m8
    $Console = $host.ui.RawUI
    $ConBuffer = $Console.BufferSize
    $ConSize = $Console.WindowSize
    $CurrWidth = $ConSize.Width
    $CurrHeight = $ConSize.Height
    if ($Height -gt $host.UI.RawUI.MaxPhysicalWindowSize.Height) {
        $Height = $host.UI.RawUI.MaxPhysicalWindowSize.Height
    }

    if ($Width -gt $host.UI.RawUI.MaxPhysicalWindowSize.Width) {
        $Width = $host.UI.RawUI.MaxPhysicalWindowSize.Width
    }
    If ($ConBuffer.Width -gt $Width ) {
        $currWidth = $Width
    }
    If ($ConBuffer.Height -gt $Height ) {
        $currHeight = $Height
    }
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($currWidth,$currHeight)
    $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.size($Width,2000)
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($Width,$Height)
}
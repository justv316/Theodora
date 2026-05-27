function fnCreateNewCharacter{
    [CmdletBinding()]
    param()
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $CharacterForm = [System.Windows.Forms.Form] @{
        Text = 'New Character Creation'
        StartPosition = 'CenterParent'
        BackColor = "#363636"
        FormBorderStyle = "FixedToolWindow"
        WindowState = "Normal"
        SizeGripStyle = "Hide"
        ClientSize = New-Object System.Drawing.Size::new(860,480)
        MinimizeBox = $false
        MaximizeBox = $false
        ShowInTaskbar = $false
        Topmost = $true
        Opacity = 0.96
        AcceptButton = $CharacterFormAcceptButton
        CancelButton = $CharacterFormBackButton
    }
    $CharacterFlowPanel = [System.Windows.Forms.FlowLayoutPanel] @{
        Location = New-Object System.Drawing.Point(24, 24)
        AutoSize = $True
        AutoSizeMode = "GrowAndShrink"
        Anchor = 'Top','Bottom'
    }
    $CharacterLayoutPanel = [System.Windows.Forms.TableLayoutPanel] @{
        Dock = "Top"
        AutoSize = $True
        ColumnCount = 1
        RowCount = 1
        CellBorderStyle = "Single"
    }
    $BackgroundLayoutPanel = [System.Windows.Forms.TableLayoutPanel] @{
        Dock = "Top"
        AutoSize = $True
        ColumnCount = 1
        RowCount = 1
        CellBorderStyle = "Single"
    }
    $ProfessionLayoutPanel = [System.Windows.Forms.TableLayoutPanel] @{
        Dock = "Top"
        AutoSize = $True
        ColumnCount = 1
        RowCount = 1
        CellBorderStyle = "Single"
    }
    $CharacterPanel = [System.Windows.Forms.Panel] @{
        Location = New-Object System.Drawing.Point(12, 12)
        Size = New-Object System.Drawing.Size(($CharacterForm.ClientSize.Width - 24), ($CharacterForm.ClientSize.Height - 24))
        Anchor = 'Top','Bottom','Left','Right'
        BackColor = "Transparent"
        BorderStyle = "FixedSingle"
    }
    $CharacterNameLabel = [System.Windows.Forms.Label] @{
        text = "Who are you?"
        Dock = "Top"
        AutoSize = $True
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",12,[System.Drawing.FontStyle]::Bold::Underline)
        ForeColor = "#e4dfc8"
        BackColor = "#646464"
        BorderStyle = "FixedSingle"
        TextAlign = "MiddleLeft"
    }
    $BackgroundLabel = [System.Windows.Forms.Label] @{
        text = "Where do you hail from?"
        Dock = "Top"
        AutoSize = $True
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",12,[System.Drawing.FontStyle]::Bold::Underline)
        ForeColor = "#e4dfc8"
        BackColor = "#646464"
        BorderStyle = "FixedSingle"
        TextAlign = "MiddleCenter"
    }
    $ProfessionLabel = [System.Windows.Forms.Label] @{
        text = "What is your profession?"
        Dock = "Top"
        AutoSize = $True
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",12,[System.Drawing.FontStyle]::Bold::Underline)
        ForeColor = "#e4dfc8"
        BackColor = "#646464"
        BorderStyle = "FixedSingle"
        TextAlign = "MiddleRight"
    }
    $CharacterNameBox = [System.Windows.Forms.TextBox] @{
        Location = New-Object System.Drawing.Point(($CharacterPanel.Location.X) + 12), (($CharacterPanel.Location.Y) + 48) 
        Size = New-Object System.Drawing.Size(180, 24)
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",10,[System.Drawing.FontStyle]::Italic)
        ForeColor = "#000000"
        BackColor = "#dadada"
        TabIndex = 0
        MaxLength = 48
        BorderStyle = "Fixed3D"
        Text = "Characters Name"  
        TextAlign = "Left"
        Dock = "Top"
    }
    $CharacterFormAcceptButton = [System.Windows.Forms.Button] @{
        Text = "Accept"
        Size = New-Object System.Drawing.Size(72, 26)
        Location = New-Object System.Drawing.Point(240, 384)
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",10,[System.Drawing.FontStyle]::Bold)
        ForeColor = "#000000"
        BackColor = "#dadada"
        TabIndex = 1
        FlatStyle = "Flat"
        DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    $CharacterFormBackButton = [System.Windows.Forms.Button] @{
        Text = "Back"
        Size = New-Object System.Drawing.Size(72, 26)
        Location = New-Object System.Drawing.Point(320, 384)
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",10,[System.Drawing.FontStyle]::Bold)
        ForeColor = "#000000"
        BackColor = "#dadada"
        TabIndex = 1
        FlatStyle = "Flat"
        DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    }

    
    $CharacterLayoutPanel.Controls.Add($CharacterNameBox, 0, 0)
    $CharacterLayoutPanel.Controls.Add($CharacterNameLabel, 0, 0)
    $BackgroundLayoutPanel.Controls.Add($BackgroundLabel, 0, 0)
    $ProfessionLayoutPanel.Controls.Add($ProfessionLabel, 0, 0)
    $CharacterFlowPanel.Controls.AddRange(@($CharacterLayoutPanel, $BackgroundLayoutPanel, $ProfessionLayoutPanel))
    $CharacterPanel.Controls.AddRange(@($CharacterFormAcceptButton, $CharacterFormBackButton))
    $CharacterForm.Controls.AddRange(@($CharacterFlowPanel, $CharacterPanel))
    [void]$CharacterForm.ShowDialog()
    $CleanupControl = {
        $Cleanup = @($CharacterForm, $CharacterPanel, $CharacterNameLabel, $CharacterNameBox, $CharacterFormAcceptButton, $CharacterFormBackButton)
        foreach ($control in $Cleanup) {
            $control.Dispose()
        }
    }
    &$CleanupControl
}
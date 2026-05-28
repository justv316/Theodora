function fnCreateNewCharacter{
    [CmdletBinding()]
    param()
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $FormSize = [System.Drawing.Size] @{
        Width = 720
        Height = 440
    }
    $CharacterForm = [System.Windows.Forms.Form] @{
        Text = 'New Character Creation'
        StartPosition = 'CenterParent'
        BackColor = "#363636"
        FormBorderStyle = "FixedToolWindow"
        WindowState = "Normal"
        SizeGripStyle = "Hide"
        ClientSize = $FormSize
        MinimizeBox = $false
        MaximizeBox = $false
        ShowInTaskbar = $false
        Topmost = $true
        Opacity = 0.985
    }
    $CharacterFlowPanel = [System.Windows.Forms.FlowLayoutPanel] @{
        Location = New-Object System.Drawing.Point(24, 24)
        AutoSize = $True
        Anchor = 'Top','Bottom'
    }
    $CharacterLayoutPanel = [System.Windows.Forms.TableLayoutPanel] @{
        Location = New-Object System.Drawing.Point(24, 24)
        Size = New-Object System.Drawing.Size(($CharacterForm.ClientSize.Width - 54), ($CharacterForm.ClientSize.Height - 54))
        ColumnCount = 1
        RowCount = 3
        Dock = "Top"
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
    $NameLayoutPanel = [System.Windows.Forms.TableLayoutPanel] @{
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
        BackColor = "Black"
        BorderStyle = "FixedSingle"
    }
    $NameLabel = [System.Windows.Forms.Label] @{
        text = "Who are you?"
        Dock = "Top"
        AutoSize = $True
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",12,[System.Drawing.FontStyle]::Bold::Underline)
        ForeColor = "#e4dfc8"
        BackColor = "#646464"
        BorderStyle = "FixedSingle"
        TextAlign = "MiddleCenter"
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
        TextAlign = "MiddleCenter"
    }
    $NameBox = [System.Windows.Forms.TextBox] @{
        AutoSize = $True
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
    $ProfessionComboBox = [System.Windows.Forms.ComboBox] @{
        Text = ""
        AutoSize = $True
        TabIndex = 1
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",10,[System.Drawing.FontStyle]::Italic)
        ForeColor = "#000000"
        Dock = "Top"
    }
    $BackgroundComboBox = [System.Windows.Forms.ComboBox] @{
        Text = ""
        AutoSize = $True
        TabIndex = 2
        Font = New-Object System.Drawing.Font("OpenDyslexicAlta",10,[System.Drawing.FontStyle]::Italic)
        ForeColor = "#000000"
        Dock = "Top"
    }

    $fnBuildForm = {
        $ProfessionArr = @("Profession1","Profession2","Profession3")
        $ProfessionArr | ForEach-Object {
            $ProfessionComboBox.Items.Add($_)
        } | Out-Null
        $BackgroundArr = @("Background1","Background2","Background3")
        $BackgroundArr | ForEach-Object {
            $BackgroundComboBox.Items.Add($_)
        } | Out-Null
        $NameLayoutPanel.Controls.Add($NameBox, 0, 0)
        $NameLayoutPanel.Controls.Add($NameLabel, 0, 0)
        $BackgroundLayoutPanel.Controls.Add($BackgroundComboBox, 0, 0)
        $BackgroundLayoutPanel.Controls.Add($BackgroundLabel, 0, 0)
        $ProfessionLayoutPanel.Controls.Add($ProfessionComboBox, 0, 0)
        $ProfessionLayoutPanel.Controls.Add($ProfessionLabel, 0, 0)
        $CharacterLayoutPanel.Controls.Add($NameLayoutPanel, 0, 0)
        $CharacterLayoutPanel.Controls.Add($BackgroundLayoutPanel, 0, 1)
        $CharacterLayoutPanel.Controls.Add($ProfessionLayoutPanel, 0, 2)
        $CharacterFlowPanel.Controls.Add($CharacterLayoutPanel)
        $CharacterForm.Controls.AddRange(@($CharacterFlowPanel, $CharacterPanel))
        [void]$CharacterForm.ShowDialog()
    }
  
    $CleanupControl = {
        $Cleanup = @($CharacterForm, $CharacterPanel, $NameLabel, $NameBox)
        foreach ($control in $Cleanup) {
            $control.Dispose()
        }
    }
    &$fnBuildForm
    &$CleanupControl
}
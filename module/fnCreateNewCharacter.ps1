function fnCreateNewCharacter{
    [CmdletBinding()]
    param()
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
            $CharacterForm = [System.Windows.Forms.Form] @{
            Text = 'New Character Creation'
            StartPosition = 'CenterParent'
            BackColor = "#363636"
            FormBorderStyle = "FixedToolWindow"
            WindowState = "Normal"
            SizeGripStyle = "Hide"
            ClientSize = New-Object System.Drawing.Size::new(600,480)
            MinimizeBox = $false
            MaximizeBox = $false
            ShowInTaskbar = $false
            Topmost = $true
            Opacity = 0.96
        }
        $CharacterPanel = [System.Windows.Forms.Panel] @{
            Location = New-Object System.Drawing.Point(12, 12)
            Size = New-Object System.Drawing.Size(576, 456)
            Anchor = 'Top','Bottom','Left','Right'
            BackColor = "Transparent"
            BorderStyle = "FixedSingle"
        }
        $CharacterNameLabel = [System.Windows.Forms.Label] @{
            text = "Character Name"
            AutoSize = $true
            location = New-Object System.Drawing.Point(($CharacterPanel.Location.X) + 12), (($CharacterPanel.Location.Y) + 6)
            Font = New-Object System.Drawing.Font("OpenDyslexicAlta",12,[System.Drawing.FontStyle]::Bold::Underline)
            ForeColor = "#000000"
            BackColor = "#dadada"
            BorderStyle = "Fixed3D"
            TextAlign = "MiddleCenter"
        }
        $CharacterNameBox = [System.Windows.Forms.TextBox] @{
            Location = New-Object System.Drawing.Point(($CharacterNameLabel.Location.X) + 12), (($CharacterNameLabel.Location.Y) + 48) 
            Size = New-Object System.Drawing.Size(180, 24)
            Font = New-Object System.Drawing.Font("OpenDyslexicAlta",10,[System.Drawing.FontStyle]::Italic)
            ForeColor = "#000000"
            BackColor = "#dadada"
            TabIndex = 0
            MaxLength = 48
            BorderStyle = "Fixed3D"
            Text = "Characters Name" 
            TextAlign = "Center"
        }



        $CharacterPanel.Controls.AddRange(@($CharacterNameLabel, $CharacterNameBox))
        $CharacterForm.Controls.AddRange(@($CharacterPanel))
        [void]$CharacterForm.ShowDialog()
        $Cleanup = @($CharacterForm, $CharacterPanel, $CharacterNameLabel, $CharacterNameBox)
        foreach ($control in $Cleanup) {
            $control.Dispose()
        }
    # ADD OTHER ELEMENTS ABOVE THIS LINE
}
function fnCreateNewCharacter{
    [CmdletBinding()]
    param()

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $CharacterForm = New-Object System.Windows.Forms.Form
    $CharacterForm.Size = New-Object System.Drawing.Size(500,400)
    $CharacterForm.StartPosition = 'CenterScreen'
    $CharacterForm.Text = 'New Character Creation'
    $CharacterForm.BackColor = "#121212"
    $CharacterForm.FormBorderStyle = "FixedDialog"

    $CharacterNameLabel = New-Object System.Windows.Forms.Label
    $CharacterNameLabel.text = "Character Name"
    $CharacterNameLabel.AutoSize = $true
    $CharacterNameLabel.location = New-Object System.Drawing.Point(20,20)
    $CharacterNameLabel.Font = New-Object System.Drawing.Font("OpenDyslexic",12,[System.Drawing.FontStyle]::Bold)
    $CharacterNameLabel.ForeColor = "#f4f4f4"
    $CharacterForm.controls.AddRange(@($CharacterNameLabel))
    [void]$CharacterForm.ShowDialog()

<#

    # ADD OTHER ELEMENTS ABOVE THIS LINE



        $FontName = $_.Name
        $FontName = $FontName -replace "[-]",""
        $FontName = $FontName.Substring(0, $FontName.Length - 4)
        $FontPath = $_.FullName
        $OpenDyslexicFont.AddFontFile("$FontPath")

    #Class Drop Down

    $CharacterClass = New-Object System.Windows.Forms.Label
    $CharacterClass.Location = New-Object System.Drawing.Point(10,20)
    $CharacterClass.Text = 'Who are you?'
    $CharacterClass.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $CharacterForm.Controls.Add($CharacterClass)

    
    $ClassBox = New-Object System.Windows.Forms.ComboBox
    $ClassBox.Location = New-Object System.Drawing.Point(10,60)
    $ClassBox.Size = New-Object System.Drawing.Size(460,30)
    $ClassBox.DropDownStyle = 'DropDownList'
    $ClassBox.Items.AddRange(@('Agent','Arcanist','Swordarm'))
    $ClassBox.SelectedIndex = 0
    $CharacterForm.Controls.Add($ClassBox)

    $CreateButton = New-Object System.Windows.Forms.Button
    $CreateButton.Location = New-Object System.Drawing.Point(10,310)
    $CreateButton.Size = New-Object System.Drawing.Size(220,40)
    $CreateButton.Text = 'Proceed'
    $CreateButton.Font = New-Object System.Drawing.Font("Segoe UI",10)

    $CreateButton.Add_Click({
        switch ($ClassBox.SelectedItem){
            'Agent'{
            }

            'Arcanist'{
            }

            'Swordarm'{
            }
        }


    })
#>
}
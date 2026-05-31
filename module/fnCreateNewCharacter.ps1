
function fnCreateNewCharacter{
    Add-Type -AssemblyName PresentationFramework
    $xamlfile = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" x:Name="Window" Title="Create New Character" WindowStartupLocation="CenterOwner" ShowInTaskbar="False" Topmost="True" FontFamily="OpenDyslexic" ResizeMode="NoResize" SizeToContent="WidthAndHeight">
    <Grid x:Name="Grid" Background="#FF404040">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel Grid.Row="0" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <TextBox x:Name = "NameBox" HorizontalAlignment="Center"  VerticalAlignment="Center" Text = "Who Are You?" BorderThickness="2,2,2,2" BorderBrush="White" FontFamily="OpenDyslexicAlta" TextWrapping="WrapWithOverflow" Height="{Binding ActualHeight, ElementName=label1, Mode=OneWay}" UndoLimit="99" AllowDrop="False" TabIndex="0" Width="{Binding ActualWidth, ElementName=BackgroundBox, Mode=OneWay}" Background="#99E0E0E0" MaxLines="1" MaxLength="32"/>
            </Border>
        </StackPanel>
        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Border BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <ComboBox x:Name = "BackgroundBox" Height="{Binding ActualHeight, ElementName=label, Mode=OneWay}" TabIndex="2" SelectedIndex="0">
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Where do You Hail?</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Background 1</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Background 2</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Background 3</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                </ComboBox>
            </Border>
        </StackPanel>
        <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <ComboBox x:Name = "ProfessionBox" Height="{Binding ActualHeight, ElementName=label, Mode=OneWay}" TabIndex="3" Width="{Binding ActualWidth, ElementName=BackgroundBox, Mode=OneWay}" SelectedIndex="0">
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">What is Your Duty?</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Profession 1</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Profession 2</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                    <ComboBoxItem>
                        <ComboBoxItem.Content>
                            <TextBlock HorizontalAlignment="Center">Profession 3</TextBlock>
                        </ComboBoxItem.Content>
                    </ComboBoxItem>
                </ComboBox>
            </Border>
        </StackPanel>
        <StackPanel Grid.Row="3" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Button x:Name = "SubmitButton" Content="Submit" Width="76" Height="24" Margin="1" FontFamily="OpenDyslexic" FontSize="10" TabIndex="4"/>
            <Button x:Name = "CancelButton" Content="Cancel" Width="76" Height="24" Margin="1" FontFamily="OpenDyslexic" FontSize="10" TabIndex="5"/>
        </StackPanel>
    </Grid>
</Window>
"@    
$fnSubmitData = {
    $CharacterObject = [PSCustomObject]@{
    Name = $Var_NameBox.Text
    Profession = $Var_ProfessionBox.Text
    Background = $Var_BackgroundBox.Text
    }
    $ExportData += $CharacterObject
    $Var_Window.Close()
    &fnBuildSavArr
}
function fnInvalidInput{
    [System.Windows.MessageBox]::Show("You must make valid selections!")
}

    $inputXAML = $xamlFile -replace "x:Name", "Name"
    [XML]$XAML = $inputXAML
    $Reader = (New-Object System.Xml.XmlNodeReader $XAML)
    $Form = [Windows.Markup.XamlReader]::Load($Reader)
    $XAML.SelectNodes("//*[@Name]") | ForEach-Object {
    try{
        Set-Variable -Name "var_$($_.Name)" -Value $form.FindName($_.Name) -ErrorAction Stop
    }catch{
    throw}
    }
    $Var_Window.Dispatcher.Invoke([Action] {}, [System.Windows.Threading.DispatcherPriority]::Render)
    $ExportData = @()

    $Var_SubmitButton.Add_Click({
        if($Var_NameBox.Text -eq "Who Are You?" -or $Var_ProfessionBox.Text -eq "What is Your Duty?" -or $Var_BackgroundBox.Text -eq "Where do You Hail?"){
            &fnInvalidInput
        }
        else{
            &$fnSubmitData
        }
    })

    $Var_CancelButton.Add_Click({
        $Var_Window.Close()
    })
    $Var_Window.ShowDialog()
 }

 function fnCreateNewCharacter{
    Add-Type -AssemblyName PresentationFramework
    [xml]$xaml = 
@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" x:Name="Window" Title="Create New Character" WindowStartupLocation="CenterOwner" ResizeMode="NoResize" ShowInTaskbar="False" Topmost="True" FontFamily="OpenDyslexic" SizeToContent="WidthAndHeight">
    <Grid x:Name="Grid" Background="#FF404040">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition
                Width="Auto"/>
            <ColumnDefinition
                Width="Auto"/>
            <ColumnDefinition
                Width="Auto"/>
        </Grid.ColumnDefinitions>
        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <TextBlock Text="Who are You?" TextDecorations="Underline" HorizontalAlignment="Center" VerticalAlignment="Center" TextAlignment="Center" Width="{Binding ActualWidth, ElementName=textBlock, Mode=OneWay}" Background="#99E0E0E0"/>
            </Border>
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <TextBox x:Name = "NameBox" HorizontalAlignment="Center"  VerticalAlignment="Center" Text = "Enter Character Name" BorderThickness="2,2,2,2" BorderBrush="White" FontFamily="OpenDyslexicAlta" TextWrapping="WrapWithOverflow" Height="{Binding ActualHeight, ElementName=label1, Mode=OneWay}" UndoLimit="99" AllowDrop="False" TabIndex="0" Width="150" Background="#99E0E0E0"/>
            </Border>
        </StackPanel>
        <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <TextBlock x:Name="textBlock" Text="Where are you From?" TextDecorations="Underline" HorizontalAlignment="Center" VerticalAlignment="Center" TextAlignment="Center" Background="#99E0E0E0"/>
            </Border>
            <Border BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <ComboBox x:Name = "BackgroundBox" Width="{Binding ActualWidth, ElementName=NameBox, Mode=OneWay}" Height="{Binding ActualHeight, ElementName=label, Mode=OneWay}" TabIndex="2" SelectedIndex="0">
                    <ComboBoxItem Content="Background 1"/>
                    <ComboBoxItem Content="Background 2"/>
                    <ComboBoxItem Content="Background 3"/>
                </ComboBox>
            </Border>
        </StackPanel>
        <StackPanel Grid.Row="3" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <TextBlock Text="What is Your Duty?" TextDecorations="Underline" HorizontalAlignment="Center" VerticalAlignment="Center" Width="{Binding ActualWidth, ElementName=textBlock, Mode=OneWay}" TextAlignment="Center" Background="#99E0E0E0"/>
            </Border>
            <Border Background= "White" BorderBrush= "Black" BorderThickness= "2,2,2,2" Height="25">
                <ComboBox x:Name = "ProfessionBox" Height="{Binding ActualHeight, ElementName=label, Mode=OneWay}" TabIndex="3" Width="149" SelectedIndex="0">
                    <ComboBoxItem Content="Profession 1"/>
                    <ComboBoxItem Content="Profession 2"/>
                    <ComboBoxItem Content="Profession 3"/>
                </ComboBox>
            </Border>
        </StackPanel>
        <StackPanel Grid.Row="4" Orientation="Horizontal" HorizontalAlignment="Center" Margin="2">
            <Button x:Name = "SubmitButton" Content="Submit" Width="76" Height="24" Margin="1" FontFamily="OpenDyslexic" FontSize="10" TabIndex="4"/>
            <Button x:Name = "CancelButton" Content="Cancel" Width="76" Height="24" Margin="1" FontFamily="OpenDyslexic" FontSize="10" TabIndex="5"/>
        </StackPanel>
    </Grid>
</Window>
"@
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
    $window.ShowDialog()
 }
$Script:Tests = @()
$Script:BuiltTests = @()
$Fonts = @("Large")
$ObjectTypes = @("ASCII","String")
$BorderTypes = @("SingleBox")
$Texts = @("I am Mommy's good little baby doll")
$Justifications = @("None", "Center")
$ColorFormats = @("--ForegroundColor Red", "--ForegroundColor Rainbow", "--BackgroundColor Red", "--BackgroundColor Rainbow")
$ManualFormats = @("--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=Red --Replace ' ','@'", "--Character=12 --Line=4 --BackgroundColor=Red", "--Character=12 --Line=4 --ForegroundColor=Red --Replace ' ','@'", "--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=White --Replace ' ','@'")


    foreach($Font in $Fonts){
        foreach($BorderType in $BorderTypes){
            foreach($Justification in $Justifications){
                foreach($ObjectType in $ObjectTypes){
                    #foreach($ColorFormat in $ColorFormats){
                        #foreach($ManualFormat in $ManualFormats){
                            Foreach($Text in $Texts){
                                $TestIdentifier = "Test: " + "$Text" + " - " + "$Font"  + " - " + "$ObjectType" + " - " + "$BorderType" + " - " + "$Justification" + " - " + "$ColorFormat" + " - " + "$ManualFormat"
                                if($BuiltTests -notcontains $TestIdentifier){
                                    $BuiltTests += $TestIdentifier
                                    $TestVar = [PSCustomObject] @{
                                        'TestIdentifier' = "Test: " + "$Text" + " - " + "$Font" + " - " + "$BorderType" + " - " + "$Justification" + " - " + "$ManualFormat"
                                        'Attempted_Text' = $Text
                                        'Font' = $Font
                                        'ObjectType' = $ObjectType
                                        'BorderType' = $BorderType
                                        'Justification' = $Justification
                                        'ColorFormatting' = $ColorFormat
                                        'ManualFormatting' = $ManualFormat
                                        'Result' = ''
                                    }
                                    $Tests += $TestVar
                                    $TestNum ++
                                }
                            }
                        #}
                    #}
                    }
            }
        }
    }
    #if(([XML] (Get-Content "E:\Documents\GitHub\PSGame\Theodora\module\xml\builttests.xml")).ChildNodes.ChildNodes.Count -ne $BuiltTests.Count){
    #    $BuiltTests | Export-Clixml -Path "E:\Documents\GitHub\PSGame\Theodora\module\xml\builttests.xml" -Force
    #}

    $Tests | Foreach-Object{
        if($_.Result -ne "Pass"){
            $Text = $_.Attempted_Text
            $Font = $_.Font
            $ObjectType = $_.ObjectType
            $BorderType = $_.BorderType
            $Justification = $_.Justification
            $ColorFormatting = $_.ColorFormatting
            $ManualFormatting = $_.ManualFormatting
            fnwriteobject "$($Text)" -Font "$($Font)" -ObjectType "$($ObjectType)" -BorderType "$($BorderType)" -Justification "$($Justification)"
            $Confirmation = Read-Host "Pass?"
            if($Confirmation -eq "Y"){
                $_.Result = "Pass"
            }
            else{
                $_.Result = "Fail"
            }
        }
    }
    #if(([XML] (Get-Content "E:\Documents\GitHub\PSGame\Theodora\module\xml\tests.xml")).ChildNodes.ChildNodes.Count -ne $Tests.Count){
    #$Tests | Export-Clixml -Path "E:\Documents\GitHub\PSGame\Theodora\module\xml\tests.xml" -Force
    #}


$Manualformatting = "--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=Red --Replace ' ','@'"
$ColorFormatting = "--TextForegroundColor Magenta --BorderBackgroundColor Red --IgnoreTextPadding --IgnoreBorderPadding"
$BorderType = "Single"
$Justification = "None"
$Font = "Graceful"
$EnforcedMaxLength = 160
$MinimumPaddingLength = 4
$InputString = "I am Mommys good little baby doll"
$ASCII = fnGetAscii -InputString $InputString -Font $Font -BorderType $BorderType
$ConstructedASCII = fnBuildObject -InputObject $ASCII -ObjectType "Boxed" -BorderType $BorderType -Justification $Justification
$DoubleBox = fnBuildObject -InputObject $ConstructedASCII -ObjectType "Boxed" -BorderType "DoubleBox" -Justification "Center"
$ButtonString = "New Game" 
$Button = {
    $Object = fnGetAscii -InputString $ButtonString -Font $Font -BorderType $BorderType
    fnBuildObject -InputObject $Object -BorderType $BorderType -Justification "None"
}

Remove-Variable ManualFormatting -ErrorAction SilentlyContinue
Remove-Variable ColorFormatting -ErrorAction SilentlyContinue
Remove-Variable ASCII -ErrorAction SilentlyContinue
Remove-Variable ConstructedASCII -ErrorAction SilentlyContinue
<#
The ObjectType specifies what IgnoreTop will be crteated 
BorderType will describe which border is used in the ObjectType
If IgnoreTop is true, following the first element, the top border will be converted into horizontal border space 
If Middle Border is true, the BottomBorder becomes a middle border line. 
#>


$GridFormatting = "--GridRange=4 1 --GridBorder=Double --GridJustification=Left --Headers=Theodora Main_Menu --HeadersFont=Graceful None --HeadersBorder=DoubleSingle Double --HeadersObjectBorder=Double DoubleSingle --HeadersJustification=Center Center --HeadersMiddleBorder=True True --HeadersIgnoreTop=False True --Buttons=Button_1 Button_2 Button_3 Button_4 --ButtonsFont=Graceful Graceful Graceful Graceful --ButtonsBorder=Double Single DoubleSingle Double --ButtonsObjectBorder=Double Single DoubleSingle Double --ButtonsJustification=None None None None"

fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=160 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridRange=4 2 --GridBorder=Double --GridJustification=Left --Headers=Theodora Main_Menu --HeadersFont=Graceful None --HeadersBorder=DoubleSingle Double --HeadersObjectBorder=Double DoubleSingle --HeadersJustification=Center Center --HeadersMiddleBorder=True True --HeadersIgnoreTop=False True --Buttons=Button_1 Button_2 Button_3 Button_4 --ButtonsFont=Graceful Graceful Graceful Graceful --ButtonsBorder=Double Single DoubleSingle Double --ButtonsObjectBorder=Double Single DoubleSingle Double --ButtonsJustification=None None None None"
fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=160 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=2 --GridBorder=Double --GridJustification=Center --Headers=Theodora Main_Menu --HeadersFont=Graceful None --HeadersBorder=DoubleSingle Double --HeadersObjectBorder=Double DoubleSingle --HeadersJustification=Center Center --HeadersMiddleBorder=True True --HeadersIgnoreTop=False True --Buttons=Button_1 Button_2 Button_3 Button_4 --ButtonsFont=Graceful Graceful Graceful Graceful --ButtonsBorder=Double Single DoubleSingle Double --ButtonsObjectBorder=Double Single DoubleSingle Double --ButtonsJustification=None None None None" -ColorFormatting "--BorderForegroundColor Red"


fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=Main_Menu --HeadersFont=Large --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=1.New_Game --ButtonsFont=Graceful --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=None" -ColorFormatting "--BorderForegroundColor Magenta"

fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=Main_Menu --HeadersFont=Large --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=1.New_Game --ButtonsFont=Graceful --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=None" -ColorFormatting "--BorderForegroundColor Magenta"


$ObjectFormatting = "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" 
$BuildFormatting = "--ObjectType=Grid --Justification=Center" 
$GridFormatting = "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=Main_Menu --HeadersFont=Large --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=1.New_Game_2.Load_Game_3.Options_4.Credits --ButtonsFont=Graceful --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=None" 
$ColorFormatting = "--BorderForegroundColor Magenta"
$ManualFormatting = "--IndexRange=33 88 --LineRange=2 7 --ForegroundColor=blue"


$ManualFormatting = "--IndexRange=33,88 33,88 --LineRange=2,7 10,15 --ForegroundColor=blue green"

$BoxedButton = 
fnBuildObject -InputObject $SubObject -BorderType $Button.Border -BuildFormatting "--ObjectType=Boxed --Justification=$($Button.Justification)"



 <Display value="{fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" 
 -BuildFormatting "--ObjectType=Grid --Justification=Center" 
 -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=Main_Menu --HeadersFont=Large --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=1.New_Game_2.Load_Game_3.Options_4.Credits --ButtonsFont=Graceful --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=Center"
 -ColorFormatting "--BorderForegroundColor Magenta" 
 -ManualFormatting "--IndexRange=32,88 29,93 --LineRange=3,8 13,28 --ForegroundColor=blue green"}"/>

 {fnwriteobject -ObjectFormatting "--InputType=Menu --EnforcedMaxLength=120 --MinimumPaddingLength=4" -BuildFormatting "--ObjectType=Grid --Justification=Center" -GridFormatting "--GridColumns=1 --GridBorder=Double --GridJustification=Center --Headers=Main_Menu --HeadersFont=Large --HeadersBorder=DoubleSingle --HeadersObjectBorder=DoubleSingle --HeadersJustification=Center --HeadersMiddleBorder=True --HeadersIgnoreTop=False --Buttons=1.New_Game_2.Load_Game_3.Options_4.Credits --ButtonsFont=Graceful --ButtonsBorder=None --ButtonsObjectBorder=Single --ButtonsJustification=Center" -ColorFormatting "--BorderForegroundColor Magenta" -ManualFormatting "--IndexRange=32,88 29,93 --LineRange=3,8 13,28 --ForegroundColor=blue green"}
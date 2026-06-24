$Script:Tests = @()
$Script:BuiltTests = @()
$Fonts = @("Large")
$ObjectTypes = @("ASCII","String")
$BuildTypes = @("SingleBox")
$Texts = @("I am Mommy's good little baby doll")
$Justifications = @("None", "Center")
$ColorFormats = @("--ForegroundColor Red", "--ForegroundColor Rainbow", "--BackgroundColor Red", "--BackgroundColor Rainbow")
$ManualFormats = @("--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=Red --Replace ' ','@'", "--Character=12 --Line=4 --BackgroundColor=Red", "--Character=12 --Line=4 --ForegroundColor=Red --Replace ' ','@'", "--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=White --Replace ' ','@'")


    foreach($Font in $Fonts){
        foreach($BuildType in $BuildTypes){
            foreach($Justification in $Justifications){
                foreach($ObjectType in $ObjectTypes){
                    #foreach($ColorFormat in $ColorFormats){
                        #foreach($ManualFormat in $ManualFormats){
                            Foreach($Text in $Texts){
                                $TestIdentifier = "Test: " + "$Text" + " - " + "$Font"  + " - " + "$ObjectType" + " - " + "$BuildType" + " - " + "$Justification" + " - " + "$ColorFormat" + " - " + "$ManualFormat"
                                if($BuiltTests -notcontains $TestIdentifier){
                                    $BuiltTests += $TestIdentifier
                                    $TestVar = [PSCustomObject] @{
                                        'TestIdentifier' = "Test: " + "$Text" + " - " + "$Font" + " - " + "$BuildType" + " - " + "$Justification" + " - " + "$ManualFormat"
                                        'Attempted_Text' = $Text
                                        'Font' = $Font
                                        'ObjectType' = $ObjectType
                                        'BuildType' = $BuildType
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
            $BuildType = $_.BuildType
            $Justification = $_.Justification
            $ColorFormatting = $_.ColorFormatting
            $ManualFormatting = $_.ManualFormatting
            fnwriteobject "$($Text)" -Font "$($Font)" -ObjectType "$($ObjectType)" -BuildType "$($BuildType)" -Justification "$($Justification)"
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
$Buildtype = "SingleDoubleBox"
$Justification = "None"
$Font = "Graceful"
$EnforcedMaxLength = 160
$MinimumPaddingLength = 4
$InputString = "I am Mommys good little baby doll"
$ASCII = fnGetAscii -InputString $InputString -Font $Font -BuildType $Buildtype
$ConstructedASCII = fnBuildObject -InputObject $ASCII -ObjectType "Boxed" -BuildType $BuildType -Justification $Justification
$DoubleBox = fnBuildObject -InputObject $ConstructedASCII -ObjectType "Boxed" -BuildType "DoubleBox" -Justification "Center"
$ButtonString = "New Game" 
$Button = {
    $Object = fnGetAscii -InputString $ButtonString -Font $Font -BuildType $Buildtype
    fnBuildObject -InputObject $Object -BuildType $BuildType -Justification "None"
}

Remove-Variable ManualFormatting -ErrorAction SilentlyContinue
Remove-Variable ColorFormatting -ErrorAction SilentlyContinue
Remove-Variable ASCII -ErrorAction SilentlyContinue
Remove-Variable ConstructedASCII -ErrorAction SilentlyContinue
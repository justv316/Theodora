$Script:Tests = @(Import-Clixml -Path "E:\Documents\GitHub\PSGame\Theodora\module\xml\tests.xml")
$Script:BuiltTests = @(Import-Clixml -Path "E:\Documents\GitHub\PSGame\Theodora\module\xml\builttests.xml")
$Fonts = @("Large")
$BuildTypes = @("SingleBox")
$Texts = @("I am Mommy's good little baby doll")
$ColorFormats = @("--ForegroundColor Red")
$ManualFormats = @("--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=Red --Replace ' ','@'", "--Character=12 --Line=4 --BackgroundColor=Red", "--Character=12 --Line=4 --ForegroundColor=Red --Replace ' ','@'", "--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=White --Replace ' ','@'")


    foreach($Font in $Fonts){
        foreach($BuildType in $BuildTypes){
            foreach($Justification in $Justifications){
                foreach($ColorFormat in $ColorFormats){
                    foreach($ManualFormat in $ManualFormats){
                        Foreach($Text in $Texts){
                            $TestIdentifier = "Test: " + "$Text" + " - " + "$Font" + " - " + "$BuildType" + " - " + "$Justification" + " - " + "$ColorFormat" + " - " + "$ManualFormat"
                            if($BuiltTests -notcontains $TestIdentifier){
                                $BuiltTests += $TestIdentifier
                                $TestVar = [PSCustomObject] @{
                                    'TestIdentifier' = "Test: " + "$Text" + " - " + "$Font" + " - " + "$BuildType" + " - " + "$Justification" + " - " + "$ManualFormat"
                                    'Attempted_Text' = $Text
                                    'Font' = $Font
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
                    }
                }
            }
        }
    }
    if(([XML] (Get-Content "E:\Documents\GitHub\PSGame\Theodora\module\xml\builttests.xml")).ChildNodes.ChildNodes.Count -ne $BuiltTests.Count){
        $BuiltTests | Export-Clixml -Path "E:\Documents\GitHub\PSGame\Theodora\module\xml\builttests.xml" -Force
    }

    $Tests | Foreach-Object{
        if($_.Result -ne "Pass"){
            $Text = $_.Attempted_Text
            $Font = $_.Font
            $BuildType = $_.BuildType
            $Justification = $_.Justification
            $ColorFormatting = $_.ColorFormatting
            $ManualFormatting = $_.ManualFormatting
            fnwriteascii "$($Text)" "$($Font)" -BuildType "$($BuildType)" -Justification "$($Justification)" -ColorFormatting "$($ColorFormatting)" -ManualFormatting "$($ManualFormatting)"
            $Confirmation = Read-Host "Pass?"
            if($Confirmation -eq "Y"){
                $_.Result = "Pass"
            }
            else{
                $_.Result = "Fail"
            }
        }
    }
    if(([XML] (Get-Content "E:\Documents\GitHub\PSGame\Theodora\module\xml\tests.xml")).ChildNodes.ChildNodes.Count -ne $Tests.Count){
    $Tests | Export-Clixml -Path "E:\Documents\GitHub\PSGame\Theodora\module\xml\tests.xml" -Force
    }

<#Failed - Missing Segmented - Manual #>
fnwriteascii "Mommy" "Small" -BuildType "SingleDoubleBox" -Justification "None" -ColorFormatting "--TextForegroundColor Magenta" -ManualFormatting "--IndexRange=8 12 --LineRange=2 4 --BackgroundColor=Red --ForegroundColor=Red --Replace ' ','@'"

$Manualformatting = "--Character=12 --Line=4 --ForegroundColor=Red --BackgroundColor=Blue --Replace ' ','@'"
$Buildtype = "SingleDoubleBox"
$Justification = "None"
$Font = "Small"
$EnforcedMaxLength = 160
$MinimumPaddingLength = 4
$InputString = "I am Mommys good little baby doll"
$ASCII = fnGetAscii $InputString $Font $Buildtype $EnforcedMaxLength $MinimumPaddingLength
$ConstructedASCII = fnBuildASCII $ASCII $BuildType $Justification 

Remove-Variable ManualFormatting -ErrorAction SilentlyContinue
Remove-Variable ColorFormatting -ErrorAction SilentlyContinue
Remove-Variable ASCII -ErrorAction SilentlyContinue
Remove-Variable ConstructedASCII -ErrorAction SilentlyContinue
function fnTestBuild{
    Import-Module ArgParser  
    $Script:Text = "I also coded in fine+tune color control"
    $Script:Font = "Large"
    $Script:BuildType = "Singlebox"
    $Script:EnforcedMaxLength = 160
    $Script:MinimumPaddingLength = 4
    $Script:Justification = "Center"
    $Script:ManualFormatting = "--IndexRange=10 15 --LineRange=1 2 --Foreground=Red --Replace ' ' '@'"
}
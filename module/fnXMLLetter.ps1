Function fnXMLLetter{
    if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Letters)){
        $Script:Letters = @{}
        $LetterFile = 'E:\Documents\GitHub\PSGame\Theodora\module\letters.xml'
        $LetterXML = [XML] (Get-Content $LetterFile)
        $LetterXML.Chars.Char | Foreach-Object {
            if($_.Name -ne 'template'){
                $Letters."$($_.Name)" = New-Object PSObject -Property @{
                    'ASCII' = $_.Data
                    'Width' = $_.Width
                    'Lines' = $_.lines
                    'Font' = $_.Font
                }
            }
        }
    }
}
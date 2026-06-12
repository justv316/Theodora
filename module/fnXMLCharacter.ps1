Function fnXMLCharacter{
    if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters)){
        $Script:Characters = @{}
        $CharacterFile = 'E:\Documents\GitHub\PSGame\Theodora\module\characters.xml'
        $CharXml = [xml] (Get-Content $CharacterFile)
        $CharXml.Chars.Char | ForEach-Object {
            $Characters[$($_.Name)] = $_.Data
        }
    }
}
function fnWriteObject{
    [CmdletBinding()]
    param(
        $InputObject,
        [String] $ObjectFormatting = ''
    )
    <#
    ObjectFormatting (Used Here)  = "
        --InputType=ASCII
        --ASCIIFont=Graceful
        --BorderType=Single
        --EnforcedMaxLength=160
        --MinimumPaddingLength=4"
    #>
    begin{
        #Parse ObjectFormatting
        $ObjectFormattingArr = $ObjectFormatting -Split ' '
        $ObjectParams = ConvertTo-Params $ObjectFormattingArr -schema @{
            InputType = [String], ''
            ASCIIFont = [String], ''
            BorderType = [String], ''
            EnforcedMaxLength = [Int],160
            MinimumPaddingLength = [Int],4
        }
        $ObjectParamsHash = @{}
        $ObjectParamsKeys = $ObjectParams.Keys
        Foreach($Key in $ObjectParamsKeys){
            $ObjectParamsHash["$Key"] = $ObjectParams[$Key].Value
        }
        $InputType = if($Null -ne $ObjectParamsHash["InputType"]){$ObjectParamsHash["InputType"]}elseif($Null -eq $BuildParamsHash["InputType"]){throw "InputType is Required."}
        $ASCIIFont = if($Null -ne $ObjectParamsHash["ASCIIFont"]){$ObjectParamsHash["ASCIIFont"]}
        $BorderType = if($Null -ne $ObjectParamsHash["BorderType"]){$ObjectParamsHash["BorderType"]}
        $Script:EnforcedMaxLength = if($Null -ne $ObjectParamsHash["EnforcedMaxLength"]){$ObjectParamsHash["EnforcedMaxLength"]}else{160}
        $Script:MinimumPaddingLength = if($Null -ne $ObjectParamsHash["MinimumPaddingLength"]){$ObjectParamsHash["MinimumPaddingLength"]}else{4}
        #End Parse ObjectFormatting
        # Build Object
        if($InputType -eq "ASCII"){
            $ASCII = fnGetAscii -InputString $InputObject -Font $ASCIIFont -BorderType $BorderType
            if($BorderType -ne "Unspecified"){
                $ConstructedASCII = fnBuildObject -InputObject $ASCII -BorderType $BorderType -BuildFormatting $BuildFormatting 
            }
            $CharacterGrid = if($ConstructedASCII -ne '' -and $Null -ne $ConstructedASCII){$ConstructedASCII}else{$ASCII}
        }
        elseif($InputType -eq "String"){
            if($BorderType -ne "Unspecified"){
                $ConstructedString = fnBuildObject -InputObject $InputObject -BorderType $BorderType -BuildFormatting $BuildFormatting
            }
            $CharacterGrid = if($ConstructedString -ne '' -and $Null -ne $ConstructedString){$ConstructedString}else{$InputObject}
        }
        elseif($InputType -eq "Menu"){
            $CharacterGrid = $InputObject
        }
    } # End Begin
    process{
        fnSetConsoleWinSize -Height ($CharacterGrid.Count+1) -Width $CharacterGrid[1].Length
        Foreach($GridLine in 1..($CharacterGrid.Count)){
            $CharacterGrid[$GridLine] | Foreach-Object {
                if($_.Index -lt $CharacterGrid[$GridLine].Count){
                    if($_.Type -ne "Padding"){
                        Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                    }
                    else{
                        Write-Host "&#xa0;" -NoNewline -ForegroundColor White
                    }
                }
                elseif($_.Index -eq $CharacterGrid[$GridLine].Count){
                    Write-Host $_.Character -ForegroundColor $_.ForegroundColor -BackgroundColor $_.BackgroundColor -NoNewline
                    Write-Host ''
                }
            }
        }
    } #end Process
} # end function
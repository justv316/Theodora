function fnWriteAscii{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String[]] $InputObject,
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet("Large","Small")]
        [String] $Font,
        [Parameter(Position=2)]
        [ValidateSet("Unspecified","SingleBox","DoubleBox","SingleDoubleBox")]
        [String] $BuildType = "Unspecified",
        [Parameter(Position=3)]
        [ValidateSet("Center","Left","Right","None")]
        [String] $Justification = "Center",
        [String] $ManualFormatting = '',
        [String] $ColorFormatting = '',
        [int]$EnforcedMaxLength = 160,
        [int]$MinimumPaddingLength = 4
    )
    <#
    ColorFormatting =  "--Foreground --Background --TextForeground --BorderForeground --TextBackground --BorderBackground" 
    #>
    begin{
        # Build Reference Hashes
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Letters)){
            fnXML "Letters"
        }
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Characters)){
            fnXML "Characters"
        }
        if(-not (Get-Variable -ErrorAction SilentlyContinue -Scope Script -Name Boxes)){
            fnXML "Boxes"
        } 

        # Create Param Hash
        $ColorFormatting = "--Foreground Rainbow --Background White"
        $ColorFormatting = $ColorFormatting -Split ' '
        $ColorParams = ConvertTo-Params $ColorFormatting -schema @{
            Foreground = [String], 'Default'
            Background = [String], 'Default'
            TextForeground = [String], 'Default'
            TextBackground = [String], 'Default'
            BorderForeground = [String], 'Default'
            BorderBackground = [String], 'Default'
        }
        $ColorParamHash = @{}
        $ColorParamKeys = $ColorParams.Keys
        Foreach($Key in $ColorParamKeys){
            $ColorParamHash["$Key"] = $ColorParams[$Key].Value
        }
        $GeneralColor = $False
        $SpecificColor = $False
        $GeneralColor = ($Null -ne $ColorParams["Foreground"] -or $Null -ne $ColorParams["Background"])
        $SpecificColor = ($Null -ne $ColorParams["TextForeground"] -or $Null -ne $ColorParams["TextBackground"] -or $Null -ne $ColorParams["BorderForeground"] -or $Null -ne $ColorParams["BorderBackground"])
        if($GeneralColor -eq $True -and $SpecificColor -eq $True){
            Throw "We cannot specify both a general color and a specific color at the same time"
            return
        }
        $BorderColors = @{"BorderForeground" = $ColorParamHash["BorderForeground"]; "BorderBackground" = $ColorParamHash["BorderBackground"]}
        $TextColors = @{"TextForeground" = $ColorParamHash["TextForeground"]; "TextBackground" = $ColorParamHash["TextBackground"]}
        $TextForegroundColor = if($Null -ne $TextColors["TextForeground"]){$TextColors["TextForeground"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
        $TextBackgroundColor = if($Null -ne $TextColors["TextBackground"]){$TextColors["TextBackground"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
        $BorderForegroundColor = if($Null -ne $BorderColors["BorderForeground"]){$BorderColors["BorderForeground"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
        $BorderBackgroundColor = if($Null -ne $BorderColors["BorderBackground"]){$BorderColors["BorderBackground"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
        $ForegroundColor = if($Null -ne $ColorParams["Foreground"]){$ColorParams["Foreground"].Value}else{"White"}
        $BackgroundColor = if($Null -ne $ColorParams["Background"]){$ColorParams["Background"].Value}else{"Black"}
        # GetASCII
        $ASCII = fnGetAscii $InputObject $Font $Buildtype $EnforcedMaxLength $MinimumPaddingLength
        $Segmented = $False
        if($BuildType -ne "Unspecified"){
            if($SpecificColor -eq $True){
                $ConstructedASCII = fnBuildASCII $ASCII $BuildType $Justification -Segmented
                $Segmented = $True
            }
            else{
                $ConstructedASCII = fnBuildASCII $ASCII $BuildType $Justification
            }
            $LineCount = $ConstructedASCII.Length
            $MaxLines = $ASCII.Length
            $LineCounter = 1
            $ASCIICounter = 1
            $Counter = 1
            #Get the number of Borderlines - Will always be at least the first and last lines
            $BorderLines = @(
                1, $ConstructedASCII.Length
            )
            #If there are more BorderLines, we add them to the array
            if(($Boxes[$($BuildType)])["OuterBorderLines"] -gt 1){
                $BorderLines += ($Boxes[$($BuildType)])["OuterBorderLines"]
                $BorderLines += $ConstructedASCII.Length - 1
            }
        }
    }
    process{
        if($BuildType -ne "Unspecified"){
            if($Segmented -eq $True){
                while($LineCounter -le $LineCount){
                    if($BorderLines -contains $LineCounter){
                        # Border Lines
                        if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                            fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                        }
                        else{
                            Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                        }
                        $LineCounter++
                    }
                    else{
                        # Text Lines
                        if($ASCIICounter -le $MaxLines){
                            if($Counter -eq 1){
                                if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                    fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                }
                                else{
                                    Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine
                                }
                                $Counter++
                                $LineCounter++
                            }
                            elseif($Counter -eq 2){
                                if($TextForegroundColor -eq 'rainbow' -or $TextBackGroundColor -eq 'rainbow'){
                                    fnWriteRainbow -ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                }
                                else{
                                    Write-Host $ConstructedASCII[$LineCounter-1]-ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -NoNewLine
                                }
                                $Counter++
                                $LineCounter++
                            }
                            elseIf($Counter -eq 3){
                                if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                    fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    Write-Host ' '
                                }
                                else{
                                    Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor
                                }
                                $Counter = 1
                                $LineCounter++
                                $ASCIICounter++
                            }
                        }
                    }
                }
            }
            elseif($Segmented -eq $False){
                foreach($Line in $ConstructedASCII){
                    if($ForegroundColor -ieq 'rainbow' -or $BackGroundColor -ieq 'rainbow'){
                        fnWriteRainbow -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -Line $Line
                    }
                    else{
                        Write-Host $Line -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
                    }
                }
            }
        }
        elseif($BuildType -eq "Unspecified"){
            foreach($Line in $ASCII){
                if($ForegroundColor -ieq 'rainbow' -or $BackGroundColor -ieq 'rainbow'){
                    fnWriteRainbow -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -Line $Line
                }
                else{
                    Write-Host $Line -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
                }
            }
        }
    } #end Process
} # end function
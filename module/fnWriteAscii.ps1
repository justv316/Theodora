function fnWriteAscii{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,Position=0)]
        [String] $InputString,
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
    ColorFormatting =  "--ForegroundColor --BackgroundColor --TextForegroundColor --BorderForegroundColor --TextBackgroundColor --BorderBackgroundColor" 
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

        # Create Color Param Hash
        $ForegroundColor = "White"
        $BackgroundColor = "Black"
        if($ColorFormatting -ne ''){
            $ColorFormattingArr = $ColorFormatting -Split ' '
            $ColorParams = ConvertTo-Params $ColorFormattingArr -schema @{
                ForegroundColor = [String], 'White'
                BackgroundColor = [String], 'Black'
                TextForegroundColor = [String], 'White'
                TextBackgroundColor = [String], 'Black'
                BorderForegroundColor = [String], 'White'
                BorderBackgroundColor = [String], 'Black'
            }
            $ColorParamHash = @{}
            $ColorParamKeys = $ColorParams.Keys
            Foreach($Key in $ColorParamKeys){
                $ColorParamHash["$Key"] = $ColorParams[$Key].Value
            }
            # Define Color Variables
            $GeneralColor = $False
            $SpecificColor = $False
            $GeneralColor = ($Null -ne $ColorParams["ForegroundColor"] -or $Null -ne $ColorParams["BackgroundColor"])
            $SpecificColor = ($Null -ne $ColorParams["TextForegroundColor"] -or $Null -ne $ColorParams["TextBackgroundColor"] -or $Null -ne $ColorParams["BorderForegroundColor"] -or $Null -ne $ColorParams["BorderBackgroundColor"])
            if($GeneralColor -eq $True -and $SpecificColor -eq $True){
                Throw "We cannot specify both a general color and a specific color at the same time"
                return
            }
            $BorderColors = @{"BorderForegroundColor" = $ColorParamHash["BorderForegroundColor"]; "BorderBackgroundColor" = $ColorParamHash["BorderBackgroundColor"]}
            $TextColors = @{"TextForegroundColor" = $ColorParamHash["TextForegroundColor"]; "TextBackgroundColor" = $ColorParamHash["TextBackgroundColor"]}
            $TextForegroundColor = if($Null -ne $TextColors["TextForegroundColor"]){$TextColors["TextForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $TextBackgroundColor = if($Null -ne $TextColors["TextBackgroundColor"]){$TextColors["TextBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
            $BorderForegroundColor = if($Null -ne $BorderColors["BorderForegroundColor"]){$BorderColors["BorderForegroundColor"]}elseif($Null -ne $ForegroundColor){$ForegroundColor}else{"White"}
            $BorderBackgroundColor = if($Null -ne $BorderColors["BorderBackgroundColor"]){$BorderColors["BorderBackgroundColor"]}elseif($Null -ne $BackgroundColor){$BackgroundColor}else{"Black"}
            $ForegroundColor = if($Null -ne $ColorParamHash["ForegroundColor"]){$ColorParamHash["ForegroundColor"]}else{"White"}
            $BackgroundColor = if($Null -ne $ColorParamHash["BackgroundColor"]){$ColorParamHash["BackgroundColor"]}else{"Black"}
        }
        # GetASCII
        $Segmented = $False
        $ASCII = fnGetAscii $InputString $Font $Buildtype $EnforcedMaxLength $MinimumPaddingLength
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
        if($ManualFormatting -ne ''){
            if($BuildType -ne "Unspecified"){
                if($ColorFormatting -ne ''){
                    fnWriteManual $ConstructedASCII $ManualFormatting -BuildType $BuildType -ColorParamHash $ColorParamHash
                }
                else{
                    fnWriteManual $ConstructedASCII $ManualFormatting -BuildType $BuildType
                }
            }
            else{
                if($ColorFormatting -ne ''){
                    fnWriteManual $ASCII $ManualFormatting -BuildType $BuildType -ColorParamHash $ColorParamHash
                }
                else{
                    fnWriteManual $ASCII $ManualFormatting -BuildType $BorderLines
                }
            }
        }
        else{
            if($BuildType -ne "Unspecified"){
                if($Segmented -eq $True){
                    while($LineCounter -le $LineCount){
                        if($BorderLines -contains $LineCounter){
                            # Border Lines
                            if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1]
                            }
                            else{
                                Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewline
                                Write-Host ''
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
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine;
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseif($Counter -eq 2){
                                    if($TextForegroundColor -eq 'rainbow' -or $TextBackGroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1]-ForegroundColor $TextForegroundColor -BackgroundColor $TextBackgroundColor -NoNewLine;
                                    }
                                    $Counter++
                                    $LineCounter++
                                }
                                elseIf($Counter -eq 3){
                                    if($BorderForegroundColor -eq 'rainbow' -or $BorderBackgroundColor -eq 'rainbow'){
                                        fnWriteRainbow -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -Line $ConstructedASCII[$LineCounter-1] -Segmented
                                        Write-Host ''
                                    }
                                    else{
                                        Write-Host $ConstructedASCII[$LineCounter-1] -ForegroundColor $BorderForegroundColor -BackgroundColor $BorderBackgroundColor -NoNewLine
                                        Write-Host ''
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
                            Write-Host $Line -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewLine;
                            Write-Host ''
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
                        Write-Host $Line -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor;
                    }
                }
            }
        }
    } #end Process
} # end function
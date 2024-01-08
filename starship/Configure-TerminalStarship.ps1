winget install starship
function InstallNerdFonts {
    Set-Location  $env:USERPROFILE
    #Download Nerd Fonts , only root
    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
    
    Set-Location $env:USERPROFILE\nerd-fonts
    
    #Download Hack font
    git sparse-checkout add patched-fonts/Hack
    
    #Install Hack font
    ./install.ps1 Hack
}

$title = 'Confirm'
$question = 'Do you want to install Hack Nerd Font?'
$choices = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    InstallNerdFonts
}

if(-not (Test-Path("$Env:USERPROFILE\.config"))){
    New-Item -Path "$Env:USERPROFILE\.config" -ItemType Directory -Verbose
}
if(-not (Test-Path("$Env:USERPROFILE\.config\powershell"))){
    New-Item -Path "$Env:USERPROFILE\.config\powershell" -ItemType Directory -Verbose
}   
if(-not (Test-Path("$Env:USERPROFILE\.starship"))){
    New-Item -Path "$Env:USERPROFILE\.starship" -ItemType Directory -Verbose
}   

New-Item $PROFILE -Force 

Add-Content -Path $PROFILE -Value '[System.Console]::OutputEncoding = [System.Text.Encoding]::ASCII'
Add-Content -Path $PROFILE -Value '$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"'
Add-Content -Path $PROFILE -Value 'Invoke-Expression (&starship init powershell)'
Add-Content -Path $PROFILE -Value '. "$env:USERPROFILE\.config\powershell\user_profile.ps1"'

Invoke-WebRequest -Uri https://raw.githubusercontent.com/niklasilves/TerminalTheme/main/starship/.starship/starship.toml -OutFile "$Env:USERPROFILE\.starship\starship.toml"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/niklasilves/TerminalTheme/main/starship/.config/user_profile.ps1 -OutFile "$Env:USERPROFILE\.config\powershell\user_profile.ps1" 
Invoke-WebRequest -Uri https://raw.githubusercontent.com/niklasilves/TerminalTheme/main/starship/.config/user_vsCode_profile.ps1 -OutFile "$Env:USERPROFILE\.config\powershell\user_vsCode_profile.ps1" 

Set-Location $PSScriptRoot

## Fix font and background of Terminal ##
$file = "$Env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$bgPathNormal = "$Env:USERPROFILE\.config\powershell\TerminalBackground.jpg"
$bgPath = $bgPathNormal.Replace("\","\\")

$font = "Hack Nerd Font Mono"
$default_regex = '(?<="defaults": {},)'
if((Get-Content $file) -match $default_regex){
    $default_regex_replace = '(?<="defaults": )[^"]*'
    (Get-Content $file -Raw) -replace $default_regex_replace, "`n`t`t{`n`t`t`t$([char]34)font$([char]34):`n`t`t`t{`n`t`t`t`t$([char]34)face$([char]34): $([char]34)$font$([char]34)`n`t`t`t},`n`t`t`t$([char]34)backgroundImage$([char]34): $([char]34)$bgPath$([char]34)`n`t`t}," | Set-Content $file
}else{
    $Font_regex = '(?<="font":)'
    #Replace fonts
    if((Get-Content $file) -match $Font_regex) {
        Write-Verbose -Message "Found font" 
        $Face_regex = '(?<="face":)'
        #Replace face
        if((Get-Content $file) -match $Face_regex){
            Write-Verbose -Message "Found face" 
            $Face_regex_Replace = '(?<="face": ")[^"]*'
            (Get-Content $file -Raw) -replace $Face_regex_Replace, $font | Set-Content $file
        }
    }

    $file = "$Env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    $newColorScheme = @"
    {
        "background": "#1A1A1A",
        "black": "#121212",
        "blue": "#2B4FFF",
        "brightBlack": "#666666",
        "brightBlue": "#5C78FF",
        "brightCyan": "#5AC8FF",
        "brightGreen": "#905AFF",
        "brightPurple": "#5EA2FF",
        "brightRed": "#BA5AFF",
        "brightWhite": "#FFFFFF",
        "brightYellow": "#685AFF",
        "cursorColor": "#FFFFFF",
        "cyan": "#28B9FF",
        "foreground": "#F1F1F1",
        "green": "#7129FF",
        "name": "xcad",
        "purple": "#2883FF",
        "red": "#A52AFF",
        "selectionBackground": "#FFFFFF",
        "white": "#F1F1F1",
        "yellow": "#3D2AFF"
    },
"@
    $newJsonText_Replace = '(?<=\s*"schemes"\s*:\s*\[)[^{]*'
    $newJsonText = (Get-Content $file -Raw) -replace $newJsonText_Replace, "`n`t`t$newColorScheme"
    $newJsonText | Set-Content -Path $file -Force

    $colorScheme = "xcad"
    $colorScheme_regex = '(?<="colorScheme":)'
    if((Get-Content $file -Raw) -match $colorScheme_regex) {
        Write-Verbose -Message "colorScheme" 
        $colorScheme_regex = '(?<="colorScheme":)'
        #Replace face
        if((Get-Content $file) -match $colorScheme_regex){
            Write-Verbose -Message "colorScheme " 
            $colorScheme_regex_Replace = '(?<="colorScheme": ")[^"]*'
            (Get-Content $file -Raw) -replace $colorScheme_regex_Replace, $colorScheme | Set-Content $file
        }
    }
}

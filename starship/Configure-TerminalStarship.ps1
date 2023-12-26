winget install starship
function InstallNerdFonts {
    Set-Location  $env:USERPROFILE
    #Download Nerd Fonts , only root
    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
    
    Set-Location $env:USERPROFILE\nerd-fonts
    
    #Download CascadiaCode font
    git sparse-checkout add patched-fonts/Hack
    
    #Install Hack font
    ./install.ps1 Hack
}

[ValidateSet('Yes','No')]
$InstallPrompt = Read-Host -Prompt "Is Nerdfont already installed?"

if ($InstallPrompt -eq 'Yes') {
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
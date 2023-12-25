function SetTherminalGitPath {
    if ($env:COMPUTERNAME -eq "ADSE-5CG2246HCG"){
        set-location "C:\_data\.DevOps\AzDevOps\iLVES365\DevOps\DevOps\TerminalTheme\Starship-Win"
    }else {
        set-location "C:\Data\github\c-shark\Therminal"
    }
}
function InstallAppsWinget {
    $Apps = 'Microsoft.PowerShell','git.git','Microsoft.VisualStudioCode','Microsoft.WindowsTerminal','starship'
    $apps | Foreach-Object { winget install $_ }
}

function InstallModules{
    Install-Module -Name z -Force -Scope CurrentUser -AllowClobber -Verbose
    Install-module -Name PSReadLine -MinimumVersion 2.2.5 -Scope CurrentUser -Force -SkipPublisherCheck -Verbose
    #Install-module -Name posh-git -Force -Scope CurrentUser -Verbose
    Install-Module -Name PSSecretScanner -Force -Scope CurrentUser -Verbose
    Install-Module -Name InvokeBuild -Force -Scope CurrentUser -Verbose
    Install-Module -Name platyPS -Force -Scope CurrentUser -Verbose
}

function InstallNerdFonts {
    cd  $env:USERPROFILE
    #Download Nerd Fonts , only root
    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
    
    cd $env:USERPROFILE\nerd-fonts
    
    #Download CascadiaCode font
    git sparse-checkout add patched-fonts/Hack
    
    #Install CascadiaCdode font
    ./install.ps1 Hack
}

function CreateDotFolders {
    cd  $env:USERPROFILE
    
    if(-not (Test-Path("$Env:USERPROFILE\.config"))){
        New-Item -Path "$Env:USERPROFILE\.config" -ItemType Directory -Verbose
    }
    if(-not (Test-Path("$Env:USERPROFILE\.config\powershell"))){
        New-Item -Path "$Env:USERPROFILE\.config\powershell" -ItemType Directory -Verbose
    }   
}

<#

#>

SetTherminalGitPath
New-Item $PROFILE -Force 
Add-Content -Path $PROFILE -Value '[System.Console]::OutputEncoding = [System.Text.Encoding]::ASCII'
Add-Content -Path $PROFILE -Value '$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"'
Add-Content -Path $PROFILE -Value '$ENV:STARSHIP_DISTRO = "者 xcad"'
Add-Content -Path $PROFILE -Value 'Invoke-Expression (&starship init powershell)'
Add-Content -Path $PROFILE -Value '. "$env:USERPROFILE\.config\powershell\user_vsCode_profile.ps1"'

Copy-Item -Path $PSScriptRoot\.starship\starship.toml -Destination $HOME\.starship\starship.toml -Force -Verbose

#Return to user profile folder
SetTherminalGitPath

#Add PowerShell Profile Script
#Invoke-WebRequest -Uri https://raw.githubusercontent.com/canix1/TerminalTheme/main/Microsoft.VSCode_profile.ps1 -OutFile "$Env:USERPROFILE\\Documents\PowerShell\Microsoft.VSCode_profile.ps1" 
Copy-Item $PSScriptRoot\.starship\starship.toml -Destination $Env:USERPROFILE\.starship\starship.toml -Force
Copy-Item $PSScriptRoot\.config\user_profile.ps1 -Destination $Env:USERPROFILE\.config\powershell\user_profile.ps1 -Force
Copy-Item $PSScriptRoot\.config\user_vsCode_profile.ps1 -Destination $Env:USERPROFILE\.config\powershell\user_vsCode_profile.ps1 -Force
#Copy-Item $PSScriptRoot\Microsoft.VSCode_profile.ps1 -Destination $Env:USERPROFILE\Documents\PowerShell\Microsoft.VSCode_profile.ps1 -Force

SetTherminalGitPath
<#

#Return to user profile folder
cd  $env:USERPROFILE

#>
#cd C:\_data\.DevOps\AzDevOps\
#User Profile

#Load Prompt config
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = ' $(Write-SecretStatus)'
Import-Module -Name PSReadLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
#Requires -Version 3.0
#Requires -Module AzureRM.Resources
#Requires -Module Azure.Storage

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupLocation,
    [string] $ResourceGroupName = 'OpSheetResourceGroup',
    [string] $TemplateUri = 'https://qtemplatestorage.blob.core.windows.net/opsheetresourcegroup-stageartifacts/opSheetRoot.json',
    [string] $TemplateParametersUri = 'https://qtemplatestorage.blob.core.windows.net/opsheetresourcegroup-stageartifacts/opSheetRoot.parameters.json',
    [string] $TemplateFile = 'c:\users\jacant\documents\microsoft\disney\opsheet\opsheetresourcegroup\opsheetresourcegroup\templates\opSheetRoot.json',
    [string] $TemplateParametersFile = 'c:\users\jacant\documents\microsoft\disney\opsheet\opsheetresourcegroup\opsheetresourcegroup\templates\opSheetRoot.parameters.json'
)

Import-Module Azure -ErrorAction SilentlyContinue

try {
    [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(" ","_"), "2.9.1")
} catch { }

Set-StrictMode -Version 3

# Create or update the resource group using the specified template file and template parameters file
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force -ErrorAction Stop

New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                   -ResourceGroupName $ResourceGroupName `
                                   -TemplateFile $TemplateFile `
                                   -TemplateParameterFile $TemplateParametersFile `
                                   -Force -Verbose

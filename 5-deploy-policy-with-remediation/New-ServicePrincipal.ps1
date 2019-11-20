# #Requires -Modules @{ ModuleName="Az"; ModuleVersion="1.7.0" }
<#
    .SYNOPSIS
    Create a Service Principal for deployments.

    .DESCRIPTION
    Creates a Service Principal, for a deployments, with Contributor access.
    A password will be generated and stored in a file within your user documents folder. (tested on Windows only)
    If a resourcegroup is specified (preferred usage), the service principal access rights will be restricted to that resourcegroup.
 
    .PARAMETER Subscription
    Subscription name or id to use.

    .PARAMETER ResourceGroupName
    Name of the resource group the SP be assigned Contributor to.
    If not used, the SP will be assigned Contributor at subscription level.

    .PARAMETER ServicePrincipalDisplayName
    Display name of the Service Principal.

    .AUTHOR
    BernardB https://github.com/baidarka
 
    .VERSION
    2.0.0 20190828 (using module Az)
    1.0.0 20181120
#>

[CmdletBinding()]
param(
    [Parameter (Mandatory=$true, HelpMessage='Subscription name or id.')]
    [ValidateNotNullorEmpty()]
    [String]$Subscription,

    [Parameter (Mandatory=$false, HelpMessage='Name of the resource group to which the SP will be assigned Contributor to.')]
    [ValidateNotNullorEmpty()]
    [String]$ResourceGroupName,

    [Parameter (Mandatory=$false, HelpMessage='Display name of the Service Principal. Defaults to Ops-[subscrName]-SP.')]
    [ValidateNotNullorEmpty()]
    [String]$ServicePrincipalDisplayName
)

begin {

    Write-Verbose "Begin"
    $ErrorActionPreference = "Stop"

    # === Variables
    $role = "Contributor"
    #$homePage = "https://localhost/{0}" -f $ServicePrincipalDisplayName
    #$identifierUri = $homePage
    
    # Login #######################################################################
    if (!(Get-AzContext)) {
        Write-Warning "AzContext is null. Please login..."
        Connect-AzAccount
    }
    Set-AzContext -Subscription $SubscriptionName

    $subName = (((Get-AzContext).Subscription.Name).Trim()) -replace '\s',''  # subscription name without spaces
    if ([string]::IsNullOrWhiteSpace($ServicePrincipalDisplayName)) {
        $ServicePrincipalDisplayName = ("Ops-{0}-SP" -f $subName)
    }

    # Define the scope for the new SP; using an explicit scope will implicitly add the role assignment in New-AzADServicePrincipal
    if ($ResourceGroupName) {
        if (! (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
            Write-Error ("Resource group '{0}' cannot be found in subscription '{1}'." -f $ResourceGroupName, $Subscription)
            exit 1
        }
        $scope = ("/subscriptions/{0}/resourceGroups/{1}" -f (Get-AzContext).Subscription.Id, $ResourceGroupName)
    } else {
        $scope = ("/subscriptions/{0}" -f (Get-AzContext).Subscription.Id)
    }
}

process {
    # Ensure that SP properties can be stored in a file
    $fileName = "ServicePrincipal_$($ServicePrincipalDisplayName).txt"
    $filePath = [System.IO.Path]::Combine([environment]::GetFolderPath("mydocuments"), $fileName)
    Write-Verbose ("SP properties will be stored in file '{0}'" -f $filePath)
    Set-Content -Path $filePath -Value ("Display name     : '{0}'" -f $ServicePrincipalDisplayName)

    # Store useful Terraform variables in a script file
    $envFileName = "variables_$($subName).ps1"
    $envFilePath = [System.IO.Path]::Combine([environment]::GetFolderPath("mydocuments"), $envFileName)
    Write-Verbose ("Terraform variables will be stored in file '{0}'" -f $envFilePath)
    Set-Content -Path $envFilePath -Value ("# Subscription '{0}'" -f ((Get-AzContext).Subscription.Name))

    # Create a new SP
    $sp = New-AzADServicePrincipal -DisplayName $ServicePrincipalDisplayName -Scope $scope

    # Grab the SP secret
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
    $unsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    # Add SP properties to file
    Add-Content -Path $filePath -Value ("SP id            : '{0}'" -f $sp.ApplicationId)
    Add-Content -Path $filePath -Value ("SP secret        : '{0}'" -f $unsecureSecret)
    Add-Content -Path $filePath -Value ("Subscription id  : '{0}'" -f (Get-AzContext).Subscription.Id)
    Add-Content -Path $filePath -Value ("Subscription name: '{0}'" -f (Get-AzContext).Subscription.Name)
    Add-Content -Path $filePath -Value ("Tenant Id        : '{0}'" -f (Get-AzContext).Tenant.Id)
    Add-Content -Path $filePath -Value ("Scope            : '{0}'" -f $scope)
    Add-Content -Path $filePath -Value ("Role             : '{0}'" -f $role)

    # Add Terraform variables to file
    Add-Content -Path $envFilePath -Value ("`$Env:ARM_SUBSCRIPTION_ID = '{0}'" -f (Get-AzContext).Subscription.Id)
    Add-Content -Path $envFilePath -Value ("`$Env:ARM_TENANT_ID = '{0}'" -f (Get-AzContext).Tenant.Id)
    Add-Content -Path $envFilePath -Value ("`$Env:ARM_CLIENT_ID = '{0}'" -f $sp.ApplicationId)
    Add-Content -Path $envFilePath -Value ("`$Env:ARM_CLIENT_SECRET = '{0}'" -f $unsecureSecret)
}
end {
    Write-Verbose "End"
}
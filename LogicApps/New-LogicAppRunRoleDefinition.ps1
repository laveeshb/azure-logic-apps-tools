##############################################################################
##
## New-LogicAppRunRoleDefinition
##
##############################################################################

<#

.SYNOPSIS

This script creates a custom role definition at the subscription scope with permissions
to enable, disable a logic app and trigger.

#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $True, HelpMessage = "The subscription Id in which to create the role definition")]
  [string]$subscriptionId
)

Select-AzSubscription -SubscriptionId $subscriptionId

$role = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()

$role.Name = 'Custom - Logic Apps execute'
$role.Description = 'Can run, enable, disable logic apps and triggers.'
$role.IsCustom = $true

$role.Actions = New-Object System.Collections.Generic.List[string]
$role.Actions.Add('Microsoft.Logic/workflows/enable/action')
$role.Actions.Add('Microsoft.Logic/workflows/disable/action')
$role.Actions.Add('Microsoft.Logic/workflows/run/action')
$role.Actions.Add('Microsoft.Logic/workflows/triggers/run/action')

$role.AssignableScopes = "/subscriptions/$($subscriptionId)"

New-AzRoleDefinition  -Role $role
Param (
    [Parameter(Mandatory = $True, Position = 1)]
    [string]$nameofAppServicePlan,
    
    [Parameter(Mandatory = $True)]
    [string]$resourceGroupName,

    [Parameter(Mandatory = $True)]
    [string]$subscriptionId,

    [Parameter(Mandatory = $True)]
    [string]$tagKeyToRemove


)


try {
    Connect-AzAccount -SubscriptionId $subscriptionId
}
catch {
    Write-Host "Failed to connect to the Azure: $_"
}

# Get the existing tags of the App Service plan
$appServicePlan = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $nameofAppServicePlan
$tags = $appServicePlan.Tags
# Environment
# Check if the tag to remove exists
if ($tags.ContainsKey($tagKeyToRemove)) {
    # Remove the desired tag
    $tags.Remove($tagKeyToRemove)

    # Update the App Service plan with the modified tags
    $appServicePlanId = $appServicePlan.Id
    $tagsObject = @{"Tags" = $tags }
    Set-AzResource -ResourceId $appServicePlanId -Tag $tagsObject.Tags

    Write-Host "Tag '$tagKeyToRemove' has been removed from the App Service plan."
}
else {
    Write-Host "Tag '$tagKeyToRemove' does not exist in the App Service plan."
}

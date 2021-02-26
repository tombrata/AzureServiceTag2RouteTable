$rt_name = "split_route"
$rg_name = "rg_tb_batch"

$region = "eastus"
$servicetags = "BatchNodeManagement.EastUS"

$tags = Get-AzNetworkServiceTag -Location $region
$batchprefixes = $tags.Values | ? {$_.Name -eq $servicetags}

$myroutetable = Get-AzRouteTable -ResourceGroupName $rg_name -Name $rt_name

$prefcount = $batchprefixes.Properties.AddressPrefixes.count
$totalcount = $prefcount

if ($totalcount -ge 400) {
    Write-Host "There are $prefcount prefixes for $servicetags. Too many routes to add. Aborting now."
    Exit
}

$i=0 
foreach ($prefix in $batchprefixes.Properties.AddressPrefixes) {

    $route_name = "BatchNodeMgmt_" + $prefix.Replace("/","_").Replace(":",".") + "_nexthopInternet"

    Add-AzRouteConfig -RouteTable $myroutetable -Name $route_name -AddressPrefix $prefix -NextHopType Internet 
    $i++
    Write-Host "Added $i route of $prefcount ..." -ForegroundColor Yellow
}

Write-Host "Committing..." 
Set-AzRouteTable -RouteTable $myroutetable
Write-Host "Finished"


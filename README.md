# AzureServiceTag2RouteTable
Sample PowerShell code to add all ranges in Azure network service tag to a route table. 
This will directly route traffic to Microsoft backbone (next hop = Internet), which will take precedence over any default route (to Firewall or forced tunneling).

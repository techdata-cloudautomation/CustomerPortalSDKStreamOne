$gitrepo="https://github.com/techdata-cloudautomation/cpsso.git"
Function ResourceGroupDeploy {
    Param( 
        [Parameter(

                Mandatory=$true,

                HelpMessage='Resource Group Name'

        )][string]$resourceGroupName        
    )
    $resourceRes =$null
    
    Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if ($notPresent)
    {
        Write-Warning "**Resource Group Name doesnot exists. Please enter the name correctly..."
        $resourceRes = "null"
    }
    else
    {
        $resourceRes =$resourceGroupName

        
    }
    
    return $resourceRes
}

Function SiteNameCheck {
    Param( 
        [Parameter(

                Mandatory=$true,

                HelpMessage='Site Name'

        )][string]$siteName        
    )
    $sitenameRes =$null
    $siteres=$null
    $siteres = Get-AzureRmWebApp -Name $siteName
    if ($siteres)
    {
       $sitenameRes = $siteName
        
    }
    else
    {
        $sitenameRes ="null"
        Write-Warning "**Site Name doesnot exists. Please enter the name correctly..."
       
    }
    
    return $sitenameRes
}
Function TokenCheck {
    Param( 
        [Parameter(

                Mandatory=$true,

                HelpMessage='Deploy Token'

        )][string]$deployToken        
    )
    $deployTokenRes =$null
    if ($deployToken)
    {
        
         $deployTokenRes = $deployToken
    }
    else{
        $deployToken ="null"

        Write-Warning "**Token cannot be empty or null. Please enter the deploy token again..."
       
    }
     
    return $deployTokenRes
}
  
    $resourcegrpname=$null
    Write-Host "Please enter Resource Group Name:" -ForegroundColor Blue
   	$Stoploop = $false
    do {
        $resourcegrpname= ResourceGroupDeploy
        #Write-Host $resourcegrpname
        if($resourcegrpname -match "null"){
            $Stoploop = $false
        }else{
            $Stoploop = $true
        }
    }
    While ($Stoploop -eq $false)
    Write-Host $resourcegrpname.ResourceGroupName
    if($resourcegrpname){
        #try{
            Write-Host "Please enter Site Name:" -ForegroundColor Blue
            $SiteNameRes = $null
            $sstoploop=$false
            do {
                $SiteNameRes = SiteNameCheck
                Write-Host $SiteNameRes
                if($SiteNameRes -match "null"){
                    $sstoploop = $false
                }else{
                    $sstoploop = $true
                }
            }
            While ($sstoploop -eq $false)
            if($SiteNameRes){
                $deploytokenRes = $null
                Write-Host "Please enter Deploy Token:" -ForegroundColor Blue       
                $dtstoploop=$false
                do {
                    $deploytokenRes = TokenCheck
                    Write-Host $deploytokenRes
                    if($deploytokenRes -match "null"){
                        $dtstoploop = $false
                    }else{
                        $dtstoploop = $true
                    }
                }
                While ($dtstoploop -eq $false)
                if($deploytokenRes){

                    # SET GitHub
                    $PropertiesObject = @{
                        token = $deploytokenRes;
                    }
                    Set-AzResource -PropertyObject $PropertiesObject `
                        -ResourceId /providers/Microsoft.Web/sourcecontrols/GitHub -ApiVersion 2015-08-01 -Force

                    # Configure GitHub deployment from your GitHub repo and deploy once.
                    $PropertiesObject1 = @{
                        repoUrl = "$gitrepo";
                        branch = "master";
                    }
                    Set-AzResource -PropertyObject $PropertiesObject1 -ResourceGroupName $resourcegrpname.ResourceGroupName `
                    -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $SiteNameRes/web `
                    -ApiVersion 2015-08-01 -Force
                }
            }
       # }catch{
           
         #   Write-Warning "Error got occured. Please try again."


       # }
    }
Write-Host "Github repository public to private change is completed"
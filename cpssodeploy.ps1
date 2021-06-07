

$applicationName = "CPSSOADAPP"
$homePage = "https://secure.com"
$appIdURI = "https://secure.com/reportingapp"
$logoutURI = "http://portal.office.com"
$removeApplicationWhenComplete = $false
$testCallRequiresDelegatePermissions = $false
$exportApplicationInfoToCSV = $true
$URIForApplicationPermissionCall = "https://graph.microsoft.com/beta/reports/getTenantSecureScores(period=1)/content"
$URIForDelegatedPermissionCall = "https://graph.microsoft.com/v1.0/users"
$ApplicationPermissions = "Reports.Read.All Application.ReadWrite.All Application.ReadWrite.OwnedBy Calendars.Read Directory.Read.All Directory.ReadWrite.All"
$DelegatedPermissions = "Directory.Read.All Group.ReadWrite.All Directory.ReadWrite.All Directory.AccessAsUser.All"

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
        $resourceRes = $resourceGroupName
    }
    else
    {
        $resourceRes ="null"

        Write-Warning "**Resource Group Name already exists. Please choose different name..."
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
        $sitenameRes ="null"

        Write-Warning "**Site Name already exists. Please choose different site name..."
        
    }
    else
    {
        $sitenameRes = $siteName
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
  
Function AddResourcePermission($requiredAccess, $exposedPermissions, $requiredAccesses, $permissionType) {
    foreach ($permission in $requiredAccesses.Trim().Split(" ")) {
        $reqPermission = $null
        $reqPermission = $exposedPermissions | Where-Object {$_.Value -contains $permission}
        Write-Host "Collected information for $($reqPermission.Value) of type $permissionType" -ForegroundColor Green
        $resourceAccess = New-Object Microsoft.Open.AzureAD.Model.ResourceAccess
        $resourceAccess.Type = $permissionType
        $resourceAccess.Id = $reqPermission.Id    
        $requiredAccess.ResourceAccess.Add($resourceAccess)
    }
}
  
Function GetRequiredPermissions($requiredDelegatedPermissions, $requiredApplicationPermissions, $reqsp) {
    $sp = $reqsp
    $appid = $sp.AppId
    $requiredAccess = New-Object Microsoft.Open.AzureAD.Model.RequiredResourceAccess
    $requiredAccess.ResourceAppId = $appid
    $requiredAccess.ResourceAccess = New-Object System.Collections.Generic.List[Microsoft.Open.AzureAD.Model.ResourceAccess]
    if ($requiredDelegatedPermissions) {
        AddResourcePermission $requiredAccess -exposedPermissions $sp.Oauth2Permissions -requiredAccesses $requiredDelegatedPermissions -permissionType "Scope"
    } 
    if ($requiredApplicationPermissions) {
        AddResourcePermission $requiredAccess -exposedPermissions $sp.AppRoles -requiredAccesses $requiredApplicationPermissions -permissionType "Role"
    }
    return $requiredAccess
}
  
Function GenerateAppKey ($fromDate, $durationInYears, $pw) {
    $endDate = $fromDate.AddYears($durationInYears) 
    $keyId = (New-Guid).ToString();
    $key = New-Object Microsoft.Open.AzureAD.Model.PasswordCredential($null, $endDate, $keyId, $fromDate, $pw)
    return $key
}
  
Function CreateAppKey($fromDate, $durationInYears, $pw) {
  
    $testKey = GenerateAppKey -fromDate $fromDate -durationInYears $durationInYears -pw $pw
  
    while ($testKey.Value -match "\+" -or $testKey.Value -match "/") {
        Write-Host "Secret contains + or / and may not authenticate correctly. Regenerating..." -ForegroundColor Yellow
        $pw = ComputePassword
        $testKey = GenerateAppKey -fromDate $fromDate -durationInYears $durationInYears -pw $pw
    }
    Write-Host "Secret doesn't contain + or /. Continuing..." -ForegroundColor Green
    $key = $testKey
  
    return $key
}
  
Function ComputePassword {
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    $aesManaged.GenerateKey()
    return [System.Convert]::ToBase64String($aesManaged.Key)
}
  
Function AddOAuth2PermissionGrants($DelegatedPermissions) {
    $resource = "https://graph.windows.net/"
    $client_id = $aadApplication.AppId
    $client_secret = $appkey.Value
    $authority = "https://login.microsoftonline.com/$tenant_id"
    $tokenEndpointUri = "$authority/oauth2/token"
    $content = "grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret&resource=$resource"
  
    $Stoploop = $false
    [int]$Retrycount = "0"
  
    do {
        try {
            $response = Invoke-RestMethod -Uri $tokenEndpointUri -Body $content -Method Post -UseBasicParsing
            Write-Host "Retrieved Access Token for Azure AD Graph API" -ForegroundColor Green
            # Assign access token
            $access_token = $response.access_token
  
            $headers = @{
                Authorization = "Bearer $access_token"
            }
  
            
            $principal = "AllPrincipals"
            $principalId = $null
            
        
  
            $postbody = @{
                clientId    = $serviceprincipal.ObjectId
                consentType = $principal
                startTime   = ((get-date).AddDays(-1)).ToString("yyyy-MM-dd")
                principalId = $principalId
                resourceId  = $graphsp.ObjectId
                scope       = $DelegatedPermissions
                expiryTime  = ((get-date).AddYears(99)).ToString("yyyy-MM-dd")
            }
  
            $postbody = $postbody | ConvertTo-Json
  
            $body = Invoke-RestMethod -Uri "https://graph.windows.net/myorganization/oauth2PermissionGrants?api-version=1.6" -Body $postbody -Method POST -Headers $headers -ContentType "application/json"
            Write-Host "Created OAuth2PermissionGrants for $DelegatedPermissions" -ForegroundColor Green
  
            $Stoploop = $true
        }
        catch {
            if ($Retrycount -gt 5) {
                Write-Host "Could not get create OAuth2PermissionGrants after 6 retries." -ForegroundColor Red
                $Stoploop = $true
            }
            else {
                Write-Host "Could not create OAuth2PermissionGrants yet. Retrying in 5 seconds..." -ForegroundColor DarkYellow
                Start-Sleep -Seconds 5
                $Retrycount ++
            }
        }
    }
    While ($Stoploop -eq $false)
}
  
  
function GetOrCreateMicrosoftGraphServicePrincipal {
    #$graphsp = Get-AzureADServicePrincipal -SearchString "Microsoft Graph"
	$graphsp = Get-AzureADServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"
    if (!$graphsp) {
        $graphsp = Get-AzureADServicePrincipal -SearchString "Microsoft.Azure.AgregatorService"
    }
    if (!$graphsp) {
        #Login-AzureRmAccount
        New-AzureRmADServicePrincipal -ApplicationId "00000003-0000-0000-c000-000000000000"
        $graphsp = Get-AzureADServicePrincipal -SearchString "Microsoft Graph"
    }
  
    return $graphsp
}
  
#Connect-AzureAd
#Write-Host (Get-AzureADTenantDetail).displayName
# Check for a Microsoft Graph Service Principal. If it doesn't exist already, create it.
$graphsp = GetOrCreateMicrosoftGraphServicePrincipal
  
$existingapp = $null
#$existingapp = get-azureadapplication -SearchString $applicationName
$existingapp = Get-AzureADApplication -Filter "DisplayName eq '$applicationName'"				   
if ($existingapp) {
    Remove-Azureadapplication -ObjectId $existingApp.objectId
}
 
$rsps = @()
if ($graphsp) {
    $rsps += $graphsp
    $tenant_id = (Get-AzureADTenantDetail).ObjectId
    $tenantName = (Get-AzureADTenantDetail).DisplayName
 #   $azureadsp = Get-AzureADServicePrincipal -SearchString "Windows Azure Active Directory"
 $azureadsp =Get-AzureADServicePrincipal -Filter "AppId eq '00000002-0000-0000-c000-000000000000'"
    $rsps += $azureadsp
  
    # Add Required Resources Access (Microsoft Graph)
    $requiredResourcesAccess = New-Object System.Collections.Generic.List[Microsoft.Open.AzureAD.Model.RequiredResourceAccess]
    $microsoftGraphRequiredPermissions = GetRequiredPermissions -reqsp $graphsp -requiredApplicationPermissions $ApplicationPermissions -requiredDelegatedPermissions $DelegatedPermissions
    $requiredResourcesAccess.Add($microsoftGraphRequiredPermissions)
  
    if ($DelegatedPermissions) {
        Write-Host "Delegated Permissions specified, preparing permissions for Azure AD Graph API"
        # Add Required Resources Access (Azure AD Graph)
        $AzureADGraphRequiredPermissions = GetRequiredPermissions -reqsp $azureadsp -requiredApplicationPermissions "Directory.ReadWrite.All"
        $requiredResourcesAccess.Add($AzureADGraphRequiredPermissions)
    }
  
  
    # Get an application key
    $pw = ComputePassword
    $fromDate = [System.DateTime]::Now
    $appKey = CreateAppKey -fromDate $fromDate -durationInYears 2 -pw $pw
  
    Write-Host "Creating the AAD application $applicationName" -ForegroundColor Blue
    $aadApplication = New-AzureADApplication -DisplayName $applicationName `
        -HomePage $homePage `
        -ReplyUrls $homePage `
        -IdentifierUris $appIdURI `
        -LogoutUrl $logoutURI `
        -RequiredResourceAccess $requiredResourcesAccess `
        -PasswordCredentials $appKey
      
    # Creating the Service Principal for the application
    $servicePrincipal = New-AzureADServicePrincipal -AppId $aadApplication.AppId
  
    Write-Host "Assigning Permissions" -ForegroundColor Yellow
    
    # Assign application permissions to the application
    foreach ($app in $requiredResourcesAccess) {
  
        $reqAppSP = $rsps | Where-Object {$_.appid -contains $app.ResourceAppId}
        Write-Host "Assigning Application permissions for $($reqAppSP.displayName)" -ForegroundColor DarkYellow
  
        foreach ($resource in $app.ResourceAccess) {
            if ($resource.Type -match "Role") {
                New-AzureADServiceAppRoleAssignment -ObjectId $serviceprincipal.ObjectId `
                    -PrincipalId $serviceprincipal.ObjectId -ResourceId $reqAppSP.ObjectId -Id $resource.Id
            }
        }
     
    }
  
    # Assign delegated permissions to the application
    if ($requiredResourcesAccess.ResourceAccess -match "Scope") {
        Write-Host "Delegated Permissions found. Assigning permissions to required user"  -ForegroundColor DarkYellow
          
        foreach ($app in $requiredResourcesAccess) {
            $appDP = @()
            $reqAppSP = $rsps | Where-Object {$_.appid -contains $app.ResourceAppId}
  
            foreach ($resource in $app.ResourceAccess) {
                if ($resource.Type -match "Scope") {
                    $permission = $graphsp.oauth2permissions | Where-Object {$_.id -contains $resource.Id}
                    $appDP += $permission.Value
                }
            }
            if ($appDP) {
                Write-Host "Adding $appDP to user" -ForegroundColor DarkYellow
                $appDPString = $appDp -join " "
                AddOAuth2PermissionGrants -DelegatedPermissions $appDPString
            }
        }
    }
      
    Write-Host "App Created" -ForegroundColor Green
    
    # Define parameters for Microsoft Graph access token retrieval
    $client_id = $aadApplication.AppId;
    $client_secret = $appkey.Value
	Write-Host $client_id
    Write-Host $client_secret										   
    $tenant_id = (Get-AzureADTenantDetail).ObjectId
    $resource = "https://graph.microsoft.com"
    $authority = "https://login.microsoftonline.com/$tenant_id"
    $tokenEndpointUri = "$authority/oauth2/token"
  
    # Get the access token using grant type password for Delegated Permissions or grant type client_credentials for Application Permissions
    if ($DelegatedPermissions -and $testCallRequiresDelegatePermissions) { 
        $content = "grant_type=password&client_id=$client_id&client_secret=$client_secret&username=$UserForDelegatedPermissions&password=$Password&resource=$resource";
        $testCallUri = $UriForDelegatedPermissionCall
    }
    else {
        $content = "grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret&resource=$resource"
        $testCallUri = $UriForApplicationPermissionCall
    }
      
      
    # Try to execute the API call 6 times
    $access_token=$null
    $Stoploop = $false
    [int]$Retrycount = "0"
    do {
        try {
            $response = Invoke-RestMethod -Uri $tokenEndpointUri -Body $content -Method Post -UseBasicParsing
            #Write-Host "Retrieved Access Token" -ForegroundColor Green
            # Assign access token
            $access_token = $response.access_token
            Write-Host $access_token
            $body = $null
  
            $body = Invoke-RestMethod `
                -Uri $testCallUri `
                -Headers @{"Authorization" = "Bearer $access_token"} `
                -ContentType "application/json" `
                -Method GET
                  
            Write-Host "Retrieved Graph content" -ForegroundColor Green
            $Stoploop = $true
        }
        catch {
            if ($Retrycount -gt 9) {
                Write-Host "Could not get Graph content after 7 retries." -ForegroundColor Red
                $Stoploop = $true
            }
            else {
                Write-Host "Could not get Graph content. Retrying in 5 seconds..." -ForegroundColor DarkYellow
                Start-Sleep -Seconds 5
                $Retrycount ++
            }
        }
    }
    While ($Stoploop -eq $false)
	Write-Host "Creating the AAD V2 application CPSSOADv2APP" -ForegroundColor Blue
   	if($access_token){
	    $convresponse = $null
		$uri="https://graph.microsoft.com/beta/applications/"
		$authheader = "Bearer " + $access_token
		$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$header.Add("Authorization",$authheader)
		$header.Add("Accept","application/json")
		$header.Add("Content-Type","application/json")
		$convAppName="CPSSOADv2APP"
		$conKeyguid = New-GUID
		$conAppPas="$conKeyguid"
		#$conAppPass=([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(($conAppPas))))
		$body = @"
{
  "@odata.context": "https://graph.microsoft.com/beta/$metadata#applications/$entity",
  "isFallbackPublicClient": false,"displayName": "$convAppName",
	"tags": [
		"supportsConvergence:true",
		"availableToOtherTenants:true",
		"accessTokenVersion:1",
		"appModelVersion:2"
	],
	"keyCredentials": [],
	   "passwordCredentials": [
			
		],
	
	"requiredResourceAccess": [
		{
			"resourceAppId": "00000003-0000-0000-c000-000000000000",
			"resourceAccess": [
				{
					"id": "e1fe6dd8-ba31-4d61-89e7-88639da4683d",
					"type": "Scope"
				}
			]
		}
	],
	"web": {
		"logoutUrl": null,
		
		"redirectUris": ["https://test.azurewebsites.net/signin-microsoft"]
		 
	}
}
"@
$convresponse = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType 'application/json' -Headers $header
  
#Write-Host $convresponse.id
#Write-Host $convresponse.appId
#Write-Host $conAppPass
}
if($convresponse.id){
	$passwordurl=$uri+$convresponse.id+"/addPassword"
		$passwordBody =@"
{   "passwordCredentials": [
			{
				
				"endDateTime": "2299-12-31T12:00:00Z",
				
				"startDateTime": "2018-06-28T23:26:22.5789369Z",
				
				"displayName": "cpsso"
			}
		]
}
"@
		$passwordcreateresponse = Invoke-RestMethod -Uri $passwordurl -Method POST -Body $passwordBody -ContentType 'application/json' -Headers $header
		Write-Host $convresponse.appId
		Write-Host $passwordcreateresponse.secretText

		if($passwordcreateresponse.keyId){
		
			$conAppPass = $passwordcreateresponse.secretText
		
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
    #Write-Host $resourcegrpname
    if($resourcegrpname){
        try{
        $resourceRes = New-AzureRmResourceGroup -Name $resourcegrpname
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
            if($deploytokenRes -match "null"){
                $dtstoploop = $false
            }else{
                $dtstoploop = $true
            }
        }
        While ($dtstoploop -eq $false)
        if($deploytokenRes){
        
        $PropertiesObject = @{
            "token" = $deploytokenRes
        }
        Set-AzResource -PropertyObject $PropertiesObject -ResourceId /providers/Microsoft.Web/sourcecontrols/GitHub -ApiVersion 2019-08-01 -Force


 


    # Start-Sleep -s 10
        $resourceRes
        $ParametersObj = @{
            applicationId=$convresponse.appId
            "application Password"=$conAppPass
            #allowedResellers=""
#"clientId (Password)"=""
#"client Secret (Password)"=""
#resellerId=""
#"SOIN (Password)"=""
#resellerName=""
#"Reseller Region"=""
#notificationEmails=""
#notificationEmailFrom=""
#notificationEmailPassword=""

            siteLocation=$resourceRes.Location
            siteName=$SiteNameRes
        }
		$convAppId = $convresponse.id
        $updateuri= $uri+$convAppId
		
		#$updateuri
        $updateURLBody =@"
{   "web": {
            "redirectUris": ["https://$SiteNameRes.azurewebsites.net/signin-microsoft"]
        }
}
"@
        $updateresponse = Invoke-RestMethod -Uri $updateuri -Method PATCH -Body $updateURLBody -ContentType 'application/json' -Headers $header
        Write-Warning "*** Please donot close the browser, Resource group deployment is in progress...."
        curl -s https://$deploytokenRes@raw.githubusercontent.com/techdata-cloudautomation/cpsso/master/azuredeploy.json > ../azuredeploy.json
        
        New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceRes.ResourceGroupName -TemplateFile ../azuredeploy.json -TemplateParameterObject $ParametersObj
        
		Write-Host "Deployment is completed. Please access the web application using the link https://$SiteNameRes.azurewebsites.net" -ForegroundColor Green
        }
        }
		
        }
        catch{
            $convAppId = $convresponse.id
            $deleteuri= $uri+$convAppId
            $deleteresponse = Invoke-RestMethod -Uri $deleteuri -Method DELETE -Body $updateURLBody -ContentType 'application/json' -Headers $header
            Write-Warning "Error got occured during Resource Group Deployment process. Please try again."
            Write-Host "Deleting the created AAD V2 applciation"


        }
    }
}	
}

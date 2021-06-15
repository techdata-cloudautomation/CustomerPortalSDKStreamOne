<p><strong><img src="https://github.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/blob/main/images/GithubBanner.jpg"alt="Customer Portal SDK - StreamOne" width="990" height="380" /></strong></p>
<p><strong>What is &ldquo;Customer Portal SDK &ndash; StreamOne&rdquo;?</strong><br />Customer Portal Software Development Kit (SDK) &ndash; StreamOne, is a subscription management web application that allows
both customers and end users to do seat adjustments for MSFT CSP.<br />
<p><img src="https://raw.githubusercontent.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/main/images/sdk.PNG" alt="" width="960" height="554" /><br /><b>
<br>There are two user levels:</b><br />&bull; The customer portal allows you to manage users, modify seat quantity and view log history, see cost prices, setup sales
margins and seat increase limits<br />&bull; The end user portal allows them to modify seat quantity and view log history, also see pre-defined sales price</p>
<p><strong>What are the key benefits?</strong><br />Firstly, it is very easy to use and there is no need to log into StreamOne. In StreamOne only administrators are able to manage users and modify seats. In Customer Portal SDK – StreamOne any approved users from your organisation can manage users and modify seats 24/7 on any device. Most importantly, your customers can also be given access to the
app to modify seat quantity so you no longer need to be involved in the process, saving you time and money. Lastly changes are effective in seconds at the click of a button within the app. With the web app you can manage multiple user access and also view the history of any license changes.<br/></p>
<p><strong>How does it work?</strong><br />The app is integrated to StreamOne Cloud Marketplace via an API. You and your customers log in from a browser using active directory credentials. Once you login for the first time it will collate all your end user details and their CSP subscriptions and display them together on one screen. The Customer Portal SDK – Streamone is currently available as a Software Development Kit (SDK). Using Github Repository and the power of Azure Resource Management (ARM) you can easily deploy it into your account. This application leverages the power of Azure for you to self-host it and easily maintain it after deployment.</p>
<p><strong>When will it be available?</strong><br />Customer Portal SDK &ndash; StreamOne is available now.</p>
<p><strong>Who will it be available to?</strong><br />It is available to all customers that have basic Azure knowledge and an Azure account.</p>
<p><strong>What does Customer Portal SDK - StreamOne look like?</strong><br />It looks great! It has a very simple and modern looking Graphical User Interface (GUI).</p>
<p><img src="https://raw.githubusercontent.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/main/images/9_Customer%20Portal%20SDK%20View.jpg?raw=true" alt="" width="770" height="410" /></p>
<p><strong>What are the customer pre-requisites?<br /></strong>&bull; Customer Portal SDK StreamOne License Terms<br />&bull; Partner API credentials<br />&bull; Azure account &amp; CSP subscription (with Global Access Level)<br />&bull; Microsoft account for login
</strong><br />&bull; O365 E-mail to trigger notifications<br />&bull;E-mail to receive notifications<br />
<p><strong>When Hosting the SDK</strong><br />&bull; Partner resources to maintain it on Azure&nbsp;<br />&bull; Estimate monthly cost ~USD4.90 (List Price, VAT Excluded)<br />App Service, Free Tier, F1, 1 GB RAM, 1 GB Storage<br />Azure SQL DB Single Database, Basic Tier. 5 DTUs, 2, 2 GB</p>
<p><strong>How to get onboarded?</strong><br />Contact SCM Customer Integrations Team according of your region:</p>
<p><strong>EUROPE</strong><br /><a href="mailto:EU.API.Support@Techdata.com">EU.API.Support@Techdata.com</a><br/><strong>CANADA</strong><br /><a href="mailto:StreamOne@Techdata.ca">StreamOne@Techdata.ca</a><br><strong>UNITED STATES</strong><br />Contact your Local Sales Rep</p>
<p><strong>Summary - Deployment using Github and Powershell Script</strong><br />We have accomplished the automation of 100% of the deployment of this SDK application. Tech Data Business Partners with basic Azue knowledge will be able to self-deploy the App. The first step is to dowload the Deployment Script at the botton of this page and use Powershell to deploy the application. The process will take around 17 minutes;</p>
<!--<p><img src="https://raw.githubusercontent.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/main/images/9_Customer%20Portal%20SDK%20View.jpg" alt="" width="645" height="772" /></p>-->
<p><strong>Pre-deployment &nbsp;Best Practices</strong></p>
<ol>
<li>Use incognito Browser</li>
<li>Make sure you have the right level of access on the Azure Directory and Subscription before deploying the App (Global Admin Rights)</li>
<li>Notice that Azure Powershell has only 20 minutes before it times out. You should prepare the Settings info forehanded.</li>
<li>In order for you to use Powershell you will need a storage account. If you have never used Powershell you will be asked for a specific Resource Group Name, Storage account Name &amp; File share Name.</li>
<li>After the deployment you can delete the storage account created to use Powershell</li>
</ol>
<p><strong>Step by Step for Deployment</strong></p>
<p>1. Downloaded the Script</p>
<p>2. Visit <u><a href="https://shell.azure.com/">https://shell.azure.com/</a></u></p>
<p>3. Upload File</p>
<p>4. Type in: cd $home</p>
<p>5. Type in: Connect-AzureAD -Confirm</p>
<p>6. Type in: ./cpssodeploy.ps1</p>
<p>7. Place the Setting as you are requested:</p>
<p><strong>SETTINGS</strong></p>
<p><strong>Resource Group Name:</strong>&nbsp;<em>Any Name&nbsp;</em></p>
<p><em>Notice that:&nbsp;The auto-deployment script must create a new Resource Group. You cannot use an existing Resource Group.</em></p>
<p><strong>Site&nbsp;Name:</strong>&nbsp;<em>This is your App URL subdomain.&nbsp; The refence that will come after&nbsp;.azurewebsites.net.</em></p>
<p><em>Notice that:&nbsp;You must insert only the subdomain, without http and .azurewebsites.net</em></p>
<p><strong>Token<em>&nbsp;</em></strong>: This is your unique token to access the Private Gihub Repository where the App Code is hosted.</em></p>
<p><strong>Location:<em>&nbsp;</em></strong><em>Your Server Location</em></p>
<p><em>Notice that:&nbsp;You cannot have any typos. Example: West Europe, North Europe, East Europe, East US, Central Canada&hellip;</em></p>
<p><strong>SQL&nbsp;password:</strong>&nbsp;&nbsp;<em>create one as you please</em></p>
<p><em>Notice that:&nbsp;You must have a password that is complex enough. Azure Password Recommendations&nbsp;<a href="https://docs.microsoft.com/en-us/previous-versions/azure/jj943764(v=azure.100)" rel="nofollow">LINK</a>. Please avoid using symbols as a last character.</em></p>
<p><strong>Allowed Resellers:</strong><em>&nbsp;e-mail to get initial access to the Application.</em></p>
<p><em>Notice that:&nbsp;It should be the same e-mail of the person deploying the Application</em></p>
<p><strong>Client ID:</strong>&nbsp;<em>Your Partner API Credentials</em></p>
<p><em>Notice that:&nbsp;This information is provided by Customer Integrations Team. If you don&rsquo;t have it, please contact us.</em></p>
<p><strong>Client&nbsp;secret</strong>:&nbsp;<em>Your Partner API Credentials</em></p>
<p><em>Notice that:&nbsp;This information is provided by Customer Integrations Team. If you don&rsquo;t have it, please contact us.</em></p>
<p><strong>Reseller&nbsp;ID:</strong>&nbsp;<em>&nbsp;Reseller Number in StreamOne</em></p>
<p><em>Notice tha</em><em>t:&nbsp;If you don&rsquo;t have this information please reach out to your Local Tech Data Contact.</em></p>
<p><strong>SOIN:&nbsp;</strong><em>Your Partner API Credentials &nbsp;</em></p>
<p><em>Notice that:&nbsp;This information is provided by Customer Integrations Team. If you don&rsquo;t have it, please contact us.</em></p>
<p><strong>Reseller&nbsp;name:&nbsp;</strong><em>Your company name</em></p>
<p><em>Notice that:&nbsp;This information can be updated later.</em></p>
<p><strong>Reseller&nbsp;region:&nbsp;</strong><em>ex: EUROPE, US, CANADA.</em></p>
<p><em>Notice that:&nbsp;Please use capital letters</em></p>
<p><strong>Notification&nbsp;emails:&nbsp;</strong><em>e-mail to receive seat change notifications</em></p>
<p><em>Notice that:&nbsp;Any e-mail. Notice that Notification E-mails and Notification E-mails from can be the same email.</em></p>
<p><strong>Notification email from:&nbsp;</strong><em>e-mail to trigger notifications</em></p>
<p><em>Notice that:&nbsp;App uses MSFT Server to trigger notifications. This e-mail should have a MSFT Account associated with it.</em></p>
<p><strong>Notification email password:&nbsp;</strong><em>password of above e-mail</em></p>
<p><em>Notice that:&nbsp;Real password of the e-mail account above.</em></p>
<p>&nbsp;<img src="https://github.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/blob/main/images/5.jpg?raw=true?raw=true" alt="" width="500" height="333" /></p>
<p><strong>After-deployment &nbsp;Best Practices</strong></p>
<p>&nbsp;First Time you login in to the Application make sure that you use the same e-mail that you have used in the field Allowed Resellers</p>
<p>&nbsp;<strong>Support Documents</strong></p>
<p><em>Auto Deployment</em></p>
<ul>
<li><a href="https://github.com/techdata-cloudautomation/cpsso/blob/master/SupportDocs/Customer%20Portal%20SDK%20StreamOne%20Deployment%20Doc_July%202020.pdf">Customer Portal SDK Auto Deployment Document</a></li>
</ul>
<p><em>Reseller User Manual</em></p>
<ul>
<li><a href="https://github.com/techdata-cloudautomation/cpsso/blob/master/SupportDocs/Customer%20Portal%20SDK%20StreamOne%201.61%20Final.pdf">Customer Portal SDK Reseller User Manual 1.61</a></li>
</ul>
<p>Manual deployments are also possible, but is a longer process that you may like to avoid.</p>
<p>In case you want to engage on manual deployment the documentation can be found in this <a href="https://github.com/techdata-cloudautomation/cpsso/tree/master/SupportDocs">link</a></p>
<p><strong>Support</strong></p>
<p>What is the process for addressing issues that arise?</p>
<p>Tech Data provides limited support for this application as it is hosted in our customer&rsquo;s private environment that we do not control.</p>
<p>Being an Open Source Code further development of the application to your needs is possible. Such self-development activities are not supported and could potentially block your use of future versions of the app.</p>
<p>Sending an e-mail will kick off the following process:</p>
<ul>
<li>Your message will be acknowledged within one business day.</li>
<li>Within the following business day, we will review your concern.</li>
<li>If needed we will pull in additional resources to gain further insight and provide guidance.</li>
<li>The team will work with you to come to a conclusion.</li>
</ul>
<p>While issue complexity varies, the goal is to resolve issues within five working days: Monday-Friday: Business Hours.</p>
<p>All communication will be confidential with very limited circulation.</p>
<p>Support request emails should be sent to each team in accordance with your region:</p>
<p><strong>EUROPE</strong><br /> <a href="mailto:EU.API.Support@TechData.com">EU.API.Support@TechData.com</a><br /><strong>CANADA</strong><br /><a href="mailto:StreamOne@Techdata.ca">StreamOne@Techdata.ca</a><br><strong>UNITED STATES</strong><br />Contact your Local Sales Rep</p>
<p><strong>CUSTOMER PORTAL SDK - VERSIONING</strong></p>
<p><strong>VERSION 1.52 Fixes:</strong></p>
<p>- MSFT Edge Bugs</p>
<p>- Customer Product Page Rendering Enhancements</p>
<p>&nbsp;<strong>VERSION 1.53 Fixes:</strong></p>
<p>- End Customer E-mail 50 characters limitation Bug</p>
<p><strong>VERSION 1.54 Fixes:</strong></p>
<p>- SDK Enterprise Reseller Limitations<br />We have fixed a limitation from App when Resellers are managing over 5 thousands licenses. Previously Azure was timing out when reading big data by APIs</p>
<p>- Price Management Bug<br />When multiplying number of licenses per unit price a price difference was noticed because of the use of 4 decimals. We have fixed this limitation and now resellers can only see 2 decimals.&nbsp;</p>
<p>- Mandatory Credit Control<br />Previously you should always have a credit amount on credit control for a Customer to seat change. This was not there by design. Now no credit amount is necessary to be stablished if not needed.</p>
<p>- Showing all MSFT products (Including Azure)<br />Previously we were hiding Azure products,&nbsp; but now all MSFT products will be visible.&nbsp;</p>
<p><em>IMPORTANT on version 1.54</em></p>
<ul>
<li><em>App is not designed yet to manage Azure Products only O365 CSP. We are now showing all MSFT products because previously some O365 Products were not showing up due to the way we were hiding Azure. Please do not provide access to your customers to Azure products because the life cycle management is not yet supported from this product in App.</em><em>&nbsp;</em></li>
</ul>
<ul>
<li><em>The option to see &ldquo;All&rdquo; companies and products from the App has been removed. Reason: this is not supported by Partner APIs and it is making the App to timeout.&nbsp; We are sorry about this inconvenience. Once this functionality is supported you maybe able to have it back.</em></li>
</ul>
<p><strong>VERSION 1.55 Fixes:</strong></p>
<p>- App Sync shows Settings Data&nbsp;<br />Previously version 1.54 was not linking correcly the existing setting data in the DB with the new App Logic.So at App UI old settings data was not visible.Version 1.55 brings a fix to this. After sincing the correct linking of data will be avaiable with previous App configuration.</p>
<p><em><strong>VERSION 1.56 and 1.57 Fixes</strong></em></p>
<ul>
<li><em>Small bugs</em><em>&nbsp;</em></li>
</ul>
<p><em><strong>VERSION 1.58 Fixes</strong></em></p>
<ul>
<li><em>Only compiled code is available.</em><em>&nbsp;</em></li>
<li><em>Bug fix for a fix for a small bug that was affecting a single Reseller.</em><em>&nbsp;</em></li>
<li><em>Third party library updates.</em><em>&nbsp;</em></li>
</ul>
<p><em><b>VERSION 1.61 Fixes</b></em></p>
<ul>
<li><em>Show prices for Addon</em></li>
<li><em>Smal bug fixes</em></li>
</ul>
<p><em><b>VERSION 1.62 Fixes</b></em></p>
<ul>
<li><em>Smal bug fixes</em></li>
</ul>
<p><em><b>VERSION 1.63 Fixes</b></em></p>
<ul>
<li><em>Smal bug fixes</em></li>
</ul>
<p><em><b>VERSION 1.64 Fixes</b></em></p>
<ul>
<li><em>Product Images Support to Private Github Repository</em></li>
</ul>
<p><em><a class="github-button" data-icon="octicon-cloud-download" aria-label="Download ntkme/github-buttons on GitHub"><b>Download App Installation Scripts</b></a></em></p>
<p><a href="https://github.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/raw/main/DeployScript/cpssodeploy.zip" target="_blank">Deployment Script</a></p>
<p><a href="https://github.com/techdata-cloudautomation/CustomerPortalSDKStreamOne/raw/main/DeployScript/Public2PrivateChange.zip" target="_blank">Public to Private Script</a></p>
<p>&nbsp;</p>

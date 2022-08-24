param ($clientId, $clientSecret, $engineVersion, $studyId)


$workingDir = "c:\EneryExemplarConsole"
$DownloadDirec = $workingDir + "\Downloads"
$engineDownloadDir = $DownloadDirec + "\engine.zip"
$studyDownloadDir = $DownloadDirec + "\study"


New-Item -Path $workingDir -ItemType Directory -Force
New-Item -Path $DownloadDirec -ItemType Directory -Force
New-Item -Path $engineDownloadDir -ItemType File -Force
New-Item -Path $studyDownloadDir -ItemType Directory -Force

$openIdAuthority = "https://login-dev.energyexemplar.com/connect/token"
$simUrl = "https://localhost:59074/1.0/engines/" + $engineVersion

# https://simulation-api-aquila.energyexemplar.com/1.0/engines

function Get-FileDownload() {
	Param ($url, $token, $output)
     
	#Greatly impacts performance when on due to a bug in the underlying implementation when used
	$global:ProgressPreference = 'SilentlyContinue'

    $tokenHeaders = @{ 
        Authorization = 'Bearer ' + $token
	};

	Invoke-RestMethod -Headers $tokenHeaders -Uri $url -Body $body -Method Get  -OutFile $output -UseBasicParsing
	$global:ProgressPreference = 'Continue'
}

function Get-AuthToken() {
	Param ($authority, $clientId, $clientSecret)
    
    $tokenBody = @{
		grant_type = "client_credentials"
		client_id = $clientId
		client_secret = $clientSecret
		scope = "cloud.api"
	};
	
	$tokenHeaders = @{ 
		content_type = "application/x-www-form-urlencoded"
	};

	$response = Invoke-RestMethod $authority -Method Post -Body $tokenBody -Headers $tokenHeaders -UseBasicParsing
	$token = $response.access_token
	return $token
}

    Write-Host $clientId
    Write-Host $clientSecret

$authToken = Get-AuthToken -Authority $openIdAuthority -ClientId $clientId -ClientSecret $clientSecret
# Get-FileDownload -Url $simUrl -Token $authToken -Output $engineDownloadDir

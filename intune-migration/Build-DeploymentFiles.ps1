# This builds the migration directory and compresses the zip files for transmission. 
# to endpoints. Don't edit without checking with me or I'll glare at you in an unpleasant manner. 
# It's included as part of this repo, but this was written as a component for Datto. 

# Start Log output 
Start-Transcript "C:\usmtlog.txt" -Force -Append 
# Define variables 
$Git = (git | Out-Null)
$USMTDir = "C:\Temp-USMT" 
$Repo = "https://github.com/dannoetc/coeus-stuff.git"
$USMTShareName = "USMT"

# Create USMT folder and share 
Write-Host -ForegroundColor Red "Creating directory $USMTDir..." 
New-Item -Type Directory -Path $USMTDir 

# Clone the Github repo with the migration script 
Write-Host -ForegroundColor Red "Cloning Github repo into $USMTDir"
try { 
	git | Out-Null 
	Write-Host -ForegroundColor Red "Git is installed, proceeding..." 
}
catch [System.Management.Automation.CommandNotFoundException] { 
	Write-Host -ForegroundColor Red "FATAL ERROR: Git is not installed, attempting to install..." 
	iwr https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe -Outfile "C:\USMT-Temp\Git-2.45.2-64-bit.exe" 
	try { 
		Start-Process "C:\USMT-Temp\Git-2.45.2-64-bit.exe" -ArgumentList "/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS='icons,ext\reg\shellhere,assoc,assoc_sh'"
	}
	catch { 
		Write-Host -ForegroundColor Red "Installation failed..." 
	}
}

& "C:\Program Files\Git\cmd\git.exe" clone $Repo $USMTDir 


# Share the resulting folder 
New-SmbShare -Name $USMTShareName -Path $USMTDir\intune-migration 
Write-Host -ForegroundColor Red "Creating share $USMTShareName in $USMTDir"...


# Compress the delivery files 
Write-Host -ForegroundColor Red "Creating delivery files..." 
Compress-Archive -Path $USMTDir\intune-migration\AADMigration -DestinationPath $USMTDir\intune-migration\AADMigration.zip 

$migrationfiles = @{
	LiteralPath="$USMTDir\intune-migration\AADMigration.zip", "$USMTDir\intune-migration\USMTGUI.exe", "$USMTDir\intune-migration\USMTGUIOD.exe"
	CompressionLevel = "Fastest"
	DestinationPath = "$USMTDir\AADMigrationFiles.zip"
	}

Compress-Archive @migrationfiles
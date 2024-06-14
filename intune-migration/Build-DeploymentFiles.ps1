Compress-Archive -Path $PsScriptRoot\AADMigration -DestinationPath $PsScriptRoot\AADMigration.zip 

$migrationfiles = @{
	LiteralPath="$PsScriptRoot\AADMigration.zip", "$PsScriptRoot\USMTGUI.exe", "$PsScriptRoot\USMTGUIOD.exe"
	CompressionLevel = "Fastest"
	DestionationPath = "$PsScriptRoot\AADMigrationFiles.zip"
	}

Compress-Archive @migrationfiles
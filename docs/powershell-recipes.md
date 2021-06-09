# PowerShell Recipes


## Remove all files (hidden, non-hidden, system, folders, etc.)

> Get-ChildItem "path" -Directory | Get-ChildItem -force | Remove-Item -Verbose -Recurse -Force
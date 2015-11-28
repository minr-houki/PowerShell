@ECHO OFF
SET SCRIPT=%~dpn0.ps1
SET ARGS=%*

powershell -command "$script = [System.IO.File]::ReadAllText('%SCRIPT%');Invoke-Expression('&{' + $script + '} %SCRIPT% %ARGS%')"

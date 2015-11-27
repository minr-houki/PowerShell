function include($path){
  $script = [System.IO.File]::ReadAllText($path)
  New-Module (Invoke-Expression("{$script}"))
}

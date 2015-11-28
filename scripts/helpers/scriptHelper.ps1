filter invoke{
  Invoke-Expression("&{$_} $args")
}

function enc{
  param(
    # In use, please add validate set as necessary.
    [ValidateSet('utf-8','shift-jis','euc-jp')]
    $encoding = 'utf-8'
  )
  [System.Text.Encoding]::GetEncoding($encoding)
}

# refer to PHP
function read_file{
  param(
    $path,    
    $encoding = (enc utf-8)
  )

  # url
  if($path -match '^(http|https)://'){
    $obj = New-Object Net.WebClient
    $obj.Encoding = $encoding
    $obj.DownloadString($path)

  # path
  } else{
    [System.IO.File]::ReadAllText($path,$encoding)
  }
}

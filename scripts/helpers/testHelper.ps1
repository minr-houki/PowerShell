# refer to Pester
function should_be($expected){
  $actual = "$input"

  if($actual -eq "$expected"){
    Write-Host ('TRUE'                     ) -ForegroundColor Green
    $true

  } else {
    Write-Host ('FALSE'                    ) -ForegroundColor Red
    Write-Host ('  [expected] ' + $expected) -ForegroundColor Red
    Write-Host ('  [actual  ] ' + $actual  ) -ForegroundColor Red
    $false
  }
}

function should_not_be($expected){
  $actual = "$input"

  if($actual -ne "$expected"){
    Write-Host ('TRUE'                     ) -ForegroundColor Green
    Write-Host ('  [expected] ' + $expected) -ForegroundColor Green
    Write-Host ('  [actual  ] ' + $actual  ) -ForegroundColor Green
    $true

  } else {
    Write-Host ('FALSE'                    ) -ForegroundColor Red
    $false
  }
}

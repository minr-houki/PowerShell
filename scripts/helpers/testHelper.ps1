#refer to Pester
function shouldbe($expected){
  $actual = "$input"

  if($actual -eq "$expected"){
    Write-Host ('TRUE') -ForegroundColor Green
    $true

  } else {
    Write-Host ('FALSE'                    ) -ForegroundColor Red
    Write-Host ('  [expected] ' + $expected) -ForegroundColor Red
    Write-Host ('  [actual  ] ' + $actual  ) -ForegroundColor Red
    $false
  }
}

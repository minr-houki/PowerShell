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

function write_summary($passedCount,$totalCount){
  $failedCount = $totalCount - $passedCount

  echo 'SUMMARY:'
  echo ('passed = ' + $passedCount.ToString())
  echo ('failed = ' + $failedCount.ToString())
  echo ('total  = ' + $totalCount.ToString())
  if($failedCount -eq 0){
    Write-Host '-> This test was passed.' -BackgroundColor DarkGreen
  } else {
    Write-Host '-> This test was failed.' -BackgroundColor DarkRed
  }
}
# refer to Pester
function should_be($expected){
  $actual = "$input"

  if($actual -eq "$expected"){
    Write-Host ('TRUE'                     ) -BackgroundColor DarkGreen
    $true

  } else {
    Write-Host ('FALSE'                    ) -BackgroundColor DarkRed
    Write-Host ('  [expected] ' + $expected) -BackgroundColor DarkRed
    Write-Host ('  [actual  ] ' + $actual  ) -BackgroundColor DarkRed
    $false
  }
}

function should_not_be($expected){
  $actual = "$input"

  if($actual -ne "$expected"){
    Write-Host ('TRUE'                     ) -BackgroundColor DarkGreen
    Write-Host ('  [expected] ' + $expected) -BackgroundColor DarkGreen
    Write-Host ('  [actual  ] ' + $actual  ) -BackgroundColor DarkGreen
    $true

  } else {
    Write-Host ('FALSE'                    ) -BackgroundColor DarkRed
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
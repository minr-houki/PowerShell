##################################################################
#test for 'testHelper.ps1'
##################################################################

#region initialize
param($self)
$parent = split-path $self -parent
Set-Alias out Out-Null

$targetDir = (join-path $parent '..\..\scripts\helpers')
$script = [System.IO.File]::ReadAllText((join-path $targetDir 'testHelper.ps1'))
New-Module (Invoke-Expression("{$script}")) | out
#endregion initialize

#region test
$passed_n = 0
$failed_n = 0

## CASE1
echo 'CASE1: same strings'
if('aaa' | shouldbe 'aaa'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

## CASE2
echo 'CASE2: different strings'
if('aaa' | shouldbe 'aab'){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE3
echo 'CASE3: same script blocks'
if({'aaa'} | shouldbe {'aaa'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

## CASE4
echo 'CASE4: different script blocks'
if({'aaa'} | shouldbe {'aab'}){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE5
echo 'CASE5: string and script block'
if('aaa' | shouldbe {'aaa'}){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE6
echo 'CASE6: script block and string'
if({'aaa'} | shouldbe 'aaa'){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## SUMMARY
echo 'SUMMARY:'
echo ('passed = ' + $passed_n.ToString())
echo ('failed = ' + $failed_n.ToString())
echo ('total  = ' + ($passed_n + $failed_n).ToString())
if($failed_n -eq 0){
  Write-Host '-> This test was passed.' -BackgroundColor DarkGreen
} else {
  Write-Host '-> This test was failed.' -BackgroundColor DarkRed
}

#endregion test

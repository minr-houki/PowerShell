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
echo 'CASE1-1: same strings(should_be)'
if('aaa' | should_be 'aaa'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

echo 'CASE1-2: same strings(should_not_be)'
if('aaa' | should_not_be 'aaa'){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE2
echo 'CASE2-1: different strings(should_be)'
if('aaa' | should_be 'aab'){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE2-2: different strings(should_not_be)'
if('aaa' | should_not_be 'aab'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

## CASE3
echo 'CASE3-1: same script blocks(should_be)'
if({'aaa'} | should_be {'aaa'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

echo 'CASE3-2: same script blocks(should_not_be)'
if({'aaa'} | should_not_be {'aaa'}){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE4
echo 'CASE4-1: different script blocks(should_be)'
if({'aaa'} | should_be {'aab'}){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE4-2: different script blocks(should_not_be)'
if({'aaa'} | should_not_be {'aab'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

## CASE5
echo 'CASE5-1: string and script block(should_be)'
if('aaa' | should_be {'aaa'}){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE5-2: string and script block(should_not_be)'
if('aaa' | should_not_be {'aaa'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
}
echo ''

## CASE6
echo 'CASE6-1: script block and string(should_be)'
if({'aaa'} | should_be 'aaa'){
  echo '-> failed.' ; $failed_n++
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE6-2: script block and string(should_not_be)'
if({'aaa'} | should_not_be 'aaa'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.' ; $failed_n++
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

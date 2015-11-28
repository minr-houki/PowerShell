##################################################################
#test for 'testHelper.ps1'
##################################################################

#region initialize
param(
  $self = $script:myInvocation.MyCommand.path
)

$parent = split-path $self -parent
Set-Alias out Out-Null

$targetDir = (join-path $parent '..\..\scripts\helpers')
$script = [System.IO.File]::ReadAllText((join-path $targetDir 'testHelper.ps1'))
New-Module (Invoke-Expression("{$script}")) | out
#endregion initialize

#region test
$passed_n = 0
$total_n  = 0

## CASE1
echo 'CASE1-1: same strings(should_be)' ; $total_n++
if('aaa' | should_be 'aaa'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.'
}
echo ''

echo 'CASE1-2: same strings(should_not_be)' ; $total_n++
if('aaa' | should_not_be 'aaa'){
  echo '-> failed.'
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE2
echo 'CASE2-1: different strings(should_be)' ; $total_n++
if('aaa' | should_be 'aab'){
  echo '-> failed.'
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE2-2: different strings(should_not_be)' ; $total_n++
if('aaa' | should_not_be 'aab'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.'
}
echo ''

## CASE3
echo 'CASE3-1: same script blocks(should_be)' ; $total_n++
if({'aaa'} | should_be {'aaa'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.'
}
echo ''

echo 'CASE3-2: same script blocks(should_not_be)' ; $total_n++
if({'aaa'} | should_not_be {'aaa'}){
  echo '-> failed.'
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

## CASE4
echo 'CASE4-1: different script blocks(should_be)' ; $total_n++
if({'aaa'} | should_be {'aab'}){
  echo '-> failed.'
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE4-2: different script blocks(should_not_be)' ; $total_n++
if({'aaa'} | should_not_be {'aab'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.'
}
echo ''

## CASE5
echo 'CASE5-1: string and script block(should_be)' ; $total_n++
if('aaa' | should_be {'aaa'}){
  echo '-> failed.'
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE5-2: string and script block(should_not_be)' ; $total_n++
if('aaa' | should_not_be {'aaa'}){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.'
}
echo ''

## CASE6
echo 'CASE6-1: script block and string(should_be)' ; $total_n++
if({'aaa'} | should_be 'aaa'){
  echo '-> failed.'
} else {
  echo '-> passed.' ; $passed_n++
}
echo ''

echo 'CASE6-2: script block and string(should_not_be)' ; $total_n++
if({'aaa'} | should_not_be 'aaa'){
  echo '-> passed.' ; $passed_n++
} else {
  echo '-> failed.'
}
echo ''

## SUMMARY
write_summary -passedCount $passed_n -totalCount $total_n

#endregion test

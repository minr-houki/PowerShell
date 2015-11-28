##################################################################
#test for 'configHelper.ps1'
##################################################################

#region initialize
param(
  $self = $script:myInvocation.MyCommand.path
)
$parent    = (split-path $self   -parent)
$targetDir = (join-path  $parent '..\..\scripts\helpers')

# !CAUTION! This function can't run when loaded as module.
filter include{
  New-Module (Invoke-Expression("{$_}"))
}
Set-Alias out Out-Null

[System.IO.File]::ReadAllText((join-path $targetDir 'scriptHelper.ps1')) | include | out
read_file (join-path $targetDir 'testHelper.ps1')   | include | out
read_file (join-path $targetDir 'configHelper.ps1') | include | out
#endregion initialize

#region test
$passed_n = 0
$total_n  = 0

$testdata1 = join-path $parent    'temp'
$testdata2 = join-path $testdata1 'testdata2.txt'
$testdata3 = join-path $testdata1 'testdata3.txt'

if(Test-Path $testdata1){Remove-Item $testdata1 -Force -Recurse}

## CASE01
Write-Host 'CASE01: directory'

echo 'test' > $testdata1
$total_n++
if($testdata1  | file: -state 'directory' | should_be {}){
  $passed_n++
}
del $testdata1 | out

$total_n++
if($testdata1  | file: -state 'directory' | should_be (iex "{New-Item $testdata1 -ItemType Directory}")){
  $passed_n++
}

$testdata1     | file: -state 'directory' | invoke | out

$total_n++
if($testdata1  | file: -state 'directory' | should_be {}){
  $passed_n++
}

## CASE02
Write-Host 'CASE02: file'

mkdir $testdata2 | out
$total_n++
if($testdata2    | file: -state 'file' | should_be {}){
  $passed_n++
}
del $testdata2   | out

$total_n++
if($testdata2    | file: -state 'file' | should_be (iex "{New-Item $testdata2 -ItemType File}")){
  $passed_n++
}

$testdata2       | file: -state 'file' | invoke | out

$total_n++
if($testdata2    | file: -state 'file' | should_be {}){
  $passed_n++
}

## CASE03
Write-Host 'CASE03: absent(file)'

$total_n++
if($testdata2  | file: -state 'absent'    | should_be (iex "{Remove-Item $testdata2}")){
  $passed_n++
}

$testdata2     | file: -state 'absent'    | invoke    | out

$total_n++
if($testdata2  | file: -state 'absent'    | should_be {}){
  $passed_n++
}

## CASE04
Write-Host 'CASE04: absent(directory)'

$total_n++
if($testdata1  | file: -state 'absent'    | should_be (iex "{Remove-Item $testdata1}")){
  $passed_n++
}

$testdata1     | file: -state 'absent'    | invoke    | out

$total_n++
if($testdata1  | file: -state 'absent'    | should_be {}){
  $passed_n++
}

$testdata1     | file: -state 'directory' | invoke    | out
$testdata2     | file: -state 'file'      | invoke    | out

# cannot delete directory that is not empty without -recurse option
$total_n++
if($testdata1  | file: -state 'absent'          | should_be {}){
  $passed_n++
}

$total_n++
if($testdata1  | file: -state 'absent' -recurse | should_be (iex "{Remove-Item $testdata1 -Force -Recurse}")){
  $passed_n++
}
$testdata1     | file: -state 'absent' -recurse | invoke    | out

$total_n++
if($testdata1  | file: -state 'absent' -recurse | should_be {}){
  $passed_n++
}

## SUMMARY
write_summary -passedCount $passed_n -totalCount $total_n

#endregion test

##################################################################
#test for 'poshPHP.ps1'
##################################################################

#region initialize
param(
  $self = $script:myInvocation.MyCommand.path
)
$parent    = (split-path $self   -parent)
$helperDir = (join-path  $parent '..\..\scripts\helpers')
$targetDir = (join-path  $parent '..\..\scripts\php')

# !CAUTION! This function can't run when loaded as module.
filter include{
  New-Module (Invoke-Expression("{$_}"))
}
Set-Alias out Out-Null

[System.IO.File]::ReadAllText((join-path $helperDir 'scriptHelper.ps1')) | include | out
read_file (join-path $helperDir 'testHelper.ps1')   | include | out
read_file (join-path $targetDir 'poshPHP.ps1')      | include | out
#endregion initialize

#region test
$passed_n = 0
$total_n  = 0

$tempDir    = Join-Path $parent  'temp'
$tempFile   = Join-Path $tempDir 'tempFile.txt'
$tempDB     = Join-Path $tempDir 'temp.db'

if(Test-Path $tempDir){Remove-Item $tempDir -Force -Recurse}
New-Item $tempDir -ItemType Directory | out

## CASE01
Write-Host 'CASE01: InvokePHPScript'

$total_n++
$result = @'
<?php
  echo("Hello,World!")."\n";
?>
'@ | InvokePHPScript
if($result | should_be "Hello,World!"){
  $passed_n++
}

## CASE02
Write-Host 'CASE02: readfile'
"How are you,World?" > $tempFile

$total_n++
if(readfile $tempFile | InvokePHPScript | should_be "How are you,World?"){
  $passed_n++
}

## CASE03
Write-Host 'CASE03: PHPHash'

$total_n++
if(PHPHash("Key","Value") | should_be "'Key'=>'Value'"){
  $passed_n++
}

## CASE04
Write-Host 'CASE04: PHPArray'

# !CAUTION! Hashtable's order can be unnexpected.
$script   = {PHPArray(@(@{aaa='AA';bbb=@{'B1'='1b'};ccc=@('c','c2')},@('dd',@{'e1'='1e'},@('f','g'))))}
$expected = @'
array(array('bbb'=>array('B1'=>'1b'),'ccc'=>array('c','c2'),'aaa'=>'AA'),array('dd',array('e1'=>'1e'),array('f','g')))
'@

$total_n++
if(& $script | should_be $expected){
  $passed_n++
}

## CASE05
Write-Host 'CASE05: array_diff'

$total_n++
if(array_diff ('A','B','C') ('A','C','D') | InvokePHPScript | should_be 'B'){
  $passed_n++
}

## CASE06
Write-Host 'CASE06: array_intersect'

$total_n++
if(array_intersect ('A','B','C') ('A','C','D') | InvokePHPScript | should_be ('A','C')){
  $passed_n++
}

## CASE07
Write-Host 'CASE07: natsort'

$total_n++
if(('10 Apple','1 Orange','3 Banana','1 apple') | natsort | InvokePHPScript | should_be ('1 Orange','1 apple','3 Banana','10 Apple')){
  $passed_n++
}

## CASE08
Write-Host 'CASE08: natcasesort'

$total_n++
if(('10 Apple','1 Orange','3 Banana','1 apple') | natcasesort | InvokePHPScript | should_be ('1 apple','1 Orange','3 Banana','10 Apple')){
  $passed_n++
}

## CASE09
Write-Host 'CASE09: number_format'
$total_n++
if((1000 | number_format 2) | InvokePHPScript | should_be '1,000.00'){
  $passed_n++
}

## CASE10
Write-Host 'CASE10: sscanf'
$total_n++
if("2015年11月22日" | sscanf "%d年%d月%d日" | InvokePHPScript | should_be ('2015','11','22')){
  $passed_n++
}

## CASE11
Write-Host 'CASE11: strspn'
$total_n++
if("0923 abc" | strspn "0123456789" | InvokePHPScript | should_be 4){
  $passed_n++
}

$total_n++
if("abc 0923" | strspn "0123456789" | InvokePHPScript | should_be 0){
  $passed_n++
}

## CASE12
Write-Host 'CASE12: strcspn'
$total_n++
if("0923 abc" | strcspn "0123456789" | InvokePHPScript | should_be 0){
  $passed_n++
}

$total_n++
if("abc 0923" | strcspn "0123456789" | InvokePHPScript | should_be 4){
  $passed_n++
}

## CASE13
Write-Host 'CASE13: strtr'
$total_n++
if('(^_^)' | strtr ('^','+') | InvokePHPScript | should_be '(+_+)'){
  $passed_n++
}

$total_n++
if('(^_^)' | strtr ('^','/') ('_','/') | InvokePHPScript | should_be '(///)'){
  $passed_n++
}

## CASE14
Write-Host 'CASE14: substr_replace'
$total_n++
if('0000000000' | substr_replace '1' 2 1 | InvokePHPScript | should_be '0010000000'){
  $passed_n++
}

$total_n++
if('0000000000' | substr_replace '1' 2 | InvokePHPScript | should_be '001'){
  $passed_n++
}

## CASE15
Write-Host 'CASE15: ucfirst'
$total_n++
if('how are you?' | ucfirst | InvokePHPScript | should_be 'How are you?'){
  $passed_n++
}

## CASE16
Write-Host 'CASE16: ucwords'
$total_n++
if('who am i?' | ucwords | InvokePHPScript | should_be 'Who Am I?'){
  $passed_n++
}

## CASE17
Write-Host 'CASE17: sqlite3_exec,sqlite3_query'
$total_n++
$result = &{
  'create table test(id integer,name string);'  | sqlite3_exec $tempDB | InvokePHPScript
  'insert into test values(1,"太郎");'          | sqlite3_exec $tempDB | InvokePHPScript
  'insert into test values(2,"花子");'          | sqlite3_exec $tempDB | InvokePHPScript
  'insert into test values(10,"ジョン");'       | sqlite3_exec $tempDB | InvokePHPScript
}
if($result | should_be ''){
  $passed_n++
}

# !CAUTION! This case fails if this script was invoked as string.
$total_n++
$result = 'select * from test where id < 10;'   | sqlite3_query $tempDB | InvokePHPScript
if($result | should_be ('1,太郎','2,花子')){
  $passed_n++
}

# !CAUTION! This case fails if this script was invoked as string.
$total_n++
$result = 'select * from test where id < 10;'   | sqlite3_query $tempDB "\t" | InvokePHPScript
if($result | should_be ('1' + "`t" + '太郎','2' + "`t" + '花子')){
  $passed_n++
}

## SUMMARY
write_summary -passedCount $passed_n -totalCount $total_n

#endregion test

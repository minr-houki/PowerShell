##################################################################
#test for 'scriptHelper.ps1'
##################################################################

#region initialize
param(
  $self = $script:myInvocation.MyCommand.path
)

# !CAUTION! This function can't run when loaded as module.
filter include{
  New-Module (Invoke-Expression("{$_}"))
}

$parent = split-path $self -parent
Set-Alias out Out-Null

$targetDir = (join-path $parent '..\..\scripts\helpers')

$script = [System.IO.File]::ReadAllText((join-path $targetDir 'testHelper.ps1'))
New-Module (Invoke-Expression("{$script}")) | out

$script = [System.IO.File]::ReadAllText((join-path $targetDir 'scriptHelper.ps1'))
New-Module (Invoke-Expression("{$script}")) | out
#endregion initialize

#region test
$passed_n = 0
$total_n  = 0

$tempDir    = Join-Path $parent  'temp'
$tempFile   = Join-Path $tempDir 'tempFile.txt'
$tempScript = Join-Path $tempDir 'tempScript.ps1'

if(Test-Path $tempDir){Remove-Item $tempDir -Force -Recurse}
New-Item $tempDir -ItemType Directory | out

## CASE1
echo 'CASE1-1: enc default' ; $total_n++
if((enc).WebName | should_be 'utf-8'){
  $passed_n++
}
echo ''

echo 'CASE1-2: enc utf-8' ; $total_n++
if((enc utf-8).WebName | should_be 'utf-8'){
  $passed_n++
}
echo ''

echo 'CASE1-3: enc shift-jis' ; $total_n++
if((enc shift-jis).WebName | should_be 'shift_jis'){
  $passed_n++
}
echo ''

echo 'CASE1-4: enc euc-jp' ; $total_n++
if((enc euc-jp).WebName | should_be 'euc-jp'){
  $passed_n++
}
echo ''

## CASE2
echo 'CASE2-1: read_file(enc default)' ; $total_n++
[System.IO.File]::WriteAllText($tempFile,'Hello,‡ŠWorld‚³‚ñ')
if(read_file $tempFile | should_be 'Hello,‡ŠWorld‚³‚ñ'){
  $passed_n++
}

echo 'CASE2-2: read_file(enc utf-8)' ; $total_n++
[System.IO.File]::WriteAllText($tempFile,'Hello,‡ŠWorld‚³‚ñ',(enc utf-8))
if(read_file $tempFile (enc utf-8) | should_be 'Hello,‡ŠWorld‚³‚ñ'){
  $passed_n++
}

# !CAUTION! This case fails if this script was invoked as string.
echo 'CASE2-3: read_file(enc shift-jis)' ; $total_n++
[System.IO.File]::WriteAllText($tempFile,'Hello,‡ŠWorld‚³‚ñ',(enc shift-jis))
if(read_file $tempFile (enc shift-jis) | should_be 'Hello,‡ŠWorld‚³‚ñ'){
  $passed_n++
}

# !CAUTION! This case fails if this script was invoked as string.
echo 'CASE2-4: read_file(enc euc-jp)' ; $total_n++
[System.IO.File]::WriteAllText($tempFile,'Hello,‡ŠWorld‚³‚ñ',(enc euc-jp))
if(read_file $tempFile (enc euc-jp) | should_be 'Hello,‡ŠWorld‚³‚ñ'){
  $passed_n++
}

echo 'CASE2-5: read_file(different encode1)' ; $total_n++
[System.IO.File]::WriteAllText($tempFile,'Hello,‡ŠWorld‚³‚ñ')
if(read_file $tempFile (enc shift-jis) | should_not_be 'Hello,‡ŠWorld‚³‚ñ'){
  $passed_n++
}

echo 'CASE2-6: read_file(different encode2)' ; $total_n++
[System.IO.File]::WriteAllText($tempFile,'Hello,‡ŠWorld‚³‚ñ',(enc shift-jis))
if(read_file $tempFile | should_not_be 'Hello,‡ŠWorld‚³‚ñ'){
  $passed_n++
}

## CASE3
echo 'CASE3: call' ; $total_n++
$script = @'
param($name)
echo "Hello,$name!"
'@
[System.IO.File]::WriteAllText($tempScript,$script)

if(read_file $tempScript | call 'GitHub' | should_be 'Hello,GitHub!'){
  $passed_n++
}
echo ''

## CASE4
echo 'CASE4: include' ; $total_n++
$script = @'
function test_include{
  param($name)
  echo "Hello,$name!"
}
'@
[System.IO.File]::WriteAllText($tempScript,$script)
read_file $tempScript | include | out
if(test_include 'GitHub' | should_be 'Hello,GitHub!'){
  $passed_n++
}
echo ''

## SUMMARY
write_summary -passedCount $passed_n -totalCount $total_n

#endregion test

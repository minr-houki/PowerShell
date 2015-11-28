filter InvokePHPScript{
    $encoding = [System.Text.Encoding]::GetEncoding("shift_jis")
    $tempfile = [System.IO.Path]::GetTempFileName()
    [System.IO.File]::WriteAllText($tempfile,$_,$encoding)
    php -f $tempfile
    del $tempfile
}

# file
function readfile($filename){
@"
<?php
  readfile('$filename')."\n";
?>
"@
}

# array
function PHPHash($src){
    "'" + $src[0] + "'=>'" + $src[1] + "'"
}

function PHPArray($src){
    switch($src.GetType().Name){
        'Object[]' {
            "array($(($src | foreach{phpArray($_)}) -join ',' ))"
        }
        'ArrayListEnumeratorSimple'{
            "array($(($src | foreach{phpArray($_)}) -join ',' ))"
        }
        'Hashtable' {
            "array($(($src.Keys | foreach{"'$_'=>$(phpArray($src[$_]))"}) -join ',' ))"
        }
        default {
            "'$src'"
        }
    }
}

function array_diff{
$paramArray = ($args | foreach{PHPArray($_)}) -join ','
@"
<?php
  echo join("\n",array_diff($paramArray))."\n";
?>
"@
}

function array_intersect{
$paramArray = ($args | foreach{PHPArray($_)}) -join ','
@"
<?php
  echo join("\n",array_intersect($paramArray))."\n";
?>
"@
}

function natsort{
  '<?php'                            + "`n" + `
  '$a = ' + (PHPArray($input)) + ';' + "`n" + `
  'natsort($a);'                     + "`n" + `
  'echo join("\n",$a)."\n";'         + "`n" + `
  '?>'
}

function natcasesort{
  '<?php'                            + "`n" + `
  '$a = ' + (PHPArray($input)) + ';' + "`n" + `
  'natcasesort($a);'                 + "`n" + `
  'echo join("\n",$a)."\n";'         + "`n" + `
  '?>'
}

# string
filter number_format($decimals = 0,$dec_point = ".",$thousands_sep = ","){
@"
<?php
  echo number_format('$_',$decimals,'$dec_point','$thousands_sep')."\n";
?>
"@
}

filter sscanf($format){
@"
<?php
  echo join("\n",sscanf("$_", "$format"))."\n";
?>
"@
}

filter strspn($mask){
@"
<?php
  echo strspn('$_','$mask')."\n";
?>
"@
}

filter strcspn($mask){
@"
<?php
  echo strcspn('$_','$mask')."\n";
?>
"@
}

filter strtr{
$paramArray =  'array(' + (($args | foreach{PHPHash($_)}) -join ',') + ')'
@"
<?php
  echo strtr('$_', $paramArray)."\n";
?>
"@
}

filter substr_replace($replacement,$start,$length = 0){
  if($length -eq 0){
@"
<?php
  echo substr_replace('$_', '$replacement', $start)."\n";
?>
"@
} else {
@"
<?php
  echo substr_replace('$_', '$replacement', $start, $length)."\n";
?>
"@
  }
}

filter ucfirst{
@"
<?php
  echo ucfirst('$_')."\n";
?>
"@
}

filter ucwords{
@"
<?php
  echo ucwords('$_')."\n";
?>
"@
}

# SQLite3
filter sqlite3_exec($path){
  '<?php'                                 + "`n" + `
  '$db = new SQLite3(' + "'$path'" + ');' + "`n" + `
  '$db->exec(' + "'$_'" + ');'            + "`n" + `
  '?>'
}

filter sqlite3_query($path,$delimiter = ','){
  '<?php'                                             + "`n" + `
  '$db = new SQLite3(' + "'$path'" + ');'             + "`n" + `
  '$result = $db->query(' + "'$_'" + ');'             + "`n" + `
  'while($row = $result->fetchArray(SQLITE3_ASSOC)){' + "`n" + `
  '  echo join("' + $delimiter + '",$row)."\n";'      + "`n" + `
  '}'                                                 + "`n" + `
  '?>'
}


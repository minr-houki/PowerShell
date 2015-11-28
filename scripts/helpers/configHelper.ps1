# refer to Ansible
# string -> script block
filter file:{
    param(
        [ValidateSet('directory','file','absent')]
        $state,

        [switch]$recurse # state=directory only
    )
    $path = $_

    switch($state){
        'directory'{
            if(Test-Path $path){
                if((Get-Item($path)).PSIsContainer){
                    Write-Host "$path is present directory." -ForegroundColor Green
                } else {
                    Write-Host "$path is present,but not directory,so it can't be made." -ForegroundColor Red
                }
                return {} #do nothing

            } else {
                Write-Host "$path is not present directory, so it will be made." -ForegroundColor Yellow
                return (Invoke-Expression "{New-Item $path -ItemType Directory}")
            }
        }

        'file'{
            if((Test-Path $path)){
                if((Get-Item($path)).PSIsContainer){
                    Write-Host "$path is present directory,so it can't be made." -ForegroundColor Red
                } else {
                    Write-Host "$path is present file." -ForegroundColor Green
                }
                return {} #do nothing

            } else {
                Write-Host "$path is not present file, so it will be made." -ForegroundColor Yellow
                return (Invoke-Expression "{New-Item $path -ItemType File}")
            }
        }

        'absent'{
            if(Test-Path $path){
                if((Get-Item($path)).PSIsContainer){
                    if($recurse.IsPresent){
                        Write-Host "$path is present directory, so it will be deleted." -ForegroundColor Yellow
                        return (Invoke-Expression "{Remove-Item $path -Force -Recurse}")

                    } elseif((dir $path).Count -eq 0) {
                        Write-Host "$path is present directory, so it will be deleted." -ForegroundColor Yellow
                        return (Invoke-Expression "{Remove-Item $path}")

                    } else {
                        Write-Host "$path is present directory,but no empty,so it can't be deleted." -ForegroundColor Red
                        return {} #do nothing
                    }

                } else {
                    Write-Host "$path is present file, so it will be deleted." -ForegroundColor Yellow
                    return (Invoke-Expression "{Remove-Item $path}")
                }

            } else {
                Write-Host "$path is absent." -ForegroundColor Green
                return {} #do nothing
            }
        }
    }
}

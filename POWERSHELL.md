## Oh My Posh Settings
```powershell
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Agnoster
```

## Powershell Functions to give it more Bash feeling

```powershell
function touch {
 $Path = $args[0]
 ni $Path | Out-Null
}

function pwd {
    Get-Location
}

function lst {
    $path = $args[0]

    if (-Not $path) {
        $path = '.' 
    }
    Write-Host ((ls $path -n -directory) -split "`n" -join "   ") "  " -ForegroundColor Green -nonewline
    Write-Host ((ls $path -n -file) -split "`n" -join "   ") -ForegroundColor Cyan
}
```

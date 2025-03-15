$dotfile = $PWD

function create_link {
    $homeItems = Get-ChildItem -Name "$dotfile\home"
    foreach ($pkg in $homeItems) {
        Write-Verbose "-t ~ -d $dotfile\home -Stow $pkg"
        & "$dotfile\Stow\stow.ps1" -t ~ -d "$dotfile\home" -dotfile -Stow $pkg
    }

    $environments = Get-ChildItem -Name "$dotfile\environment"
    foreach ($i in $environments) {
        $envPath = (Get-Item -Path "env:$i").Value
        $pkgs = Get-ChildItem -Name "$dotfile\environment\$i"
        foreach ($pkg in $pkgs) {
            Write-Verbose "-t $envPath -d $dotfile\environment\$i -Stow $pkg"
            & "$dotfile\Stow\stow.ps1" -t $envPath -d "$dotfile\environment\$i" -dotfile -Stow $pkg
        }
    }
}

git clone https://github.com/NanShanFish/Stow.git --depth=1
if (-not $?) {
    exit 1
}
create_link
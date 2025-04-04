Remove-Item -Path Alias:rm -ErrorAction SilentlyContinue
Remove-Item -Path Alias:ls -ErrorAction SilentlyContinue
Remove-Item -Path Alias:cat -ErrorAction SilentlyContinue
Remove-Item -Path Alias:echo -ErrorAction SilentlyContinue
Remove-Item -Path Alias:mv -ErrorAction SilentlyContinue
Remove-Item -Path Alias:cp -ErrorAction SilentlyContinue
Remove-Item -Path Alias:kill -ErrorAction SilentlyContinue

# ===========================================================
# ALIAS
# ===========================================================
Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force
Set-Alias -Name v -Value nvim
Set-Alias -Name lG -Value lazygit
Set-Alias -Name os -Value fastfetch
Set-Alias -Name f -Value fy
Set-Alias -Name rsort -Value $env:SCOOP\shims\sort.exe

# ===========================================================
# ENVIRONMENTS
# ===========================================================
$pathArray = $env:Path -split ';'
if ($pathArray[0] -ne "~\.local\bin") {
	$env:Path = "~\.local\bin;" + $env:Path
}
$env:YAZI_FILE_ONE="D:\SoftWare\Scoop\apps\git\current\usr\bin\file.exe"
$env:FZF_DEFAULT_OPTS="--layout=reverse --height=40%"

# ===========================================================
# KEYBIND
# ===========================================================
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord

# ===========================================================
# PROMPT
# ===========================================================
function prompt {
	$dateTime = get-date -Format "yy/MM/dd-HH:mm"

		$fullPath = $pwd.ProviderPath

		$lst = ($fullPath -split '\\')
		if ($lst.Length-1 -gt 3) {
			$shortPath = "$($lst[0])\..\$($lst[-2])\$($lst[-1])"
		} else {
			$shortPath = $fullPath
		}
	write-host "-[" -NoNewline -ForegroundColor Gray
		write-host "$shortPath" -NoNewline -ForegroundColor Magenta
		write-host "]-[" -NoNewline
		write-host "$dateTime" -NoNewline -ForegroundColor Green
		write-host "]" -ForegroundColor Gray
		write-host ">" -NoNewline -ForegroundColor Yellow
		return " "
}
# ===========================================================
# ZOXIDE
# ===========================================================
function global:__zoxide_bin {
	$encoding = [Console]::OutputEncoding
		try {
			[Console]::OutputEncoding = [System.Text.Utf8Encoding]::new()
				$result = zoxide @args
					return $result
		} finally {
			[Console]::OutputEncoding = $encoding
		}
}
function global:__zoxide_pwd {
	$cwd = Get-Location
		if ($cwd.Provider.Name -eq "FileSystem") {
			$cwd.ProviderPath
		}
}
function global:__zoxide_cd($dir, $literal) {
	$dir = if ($literal) {
		Set-Location -LiteralPath $dir -Passthru -ErrorAction Stop
	} else {
		if ($dir -eq '-' -and ($PSVersionTable.PSVersion -lt 6.1)) {
			Write-Error "cd - is not supported below PowerShell 6.1. Please upgrade your version of PowerShell."
		}
		elseif ($dir -eq '+' -and ($PSVersionTable.PSVersion -lt 6.2)) {
			Write-Error "cd + is not supported below PowerShell 6.2. Please upgrade your version of PowerShell."
		}
		else {
			Set-Location -Path $dir -Passthru -ErrorAction Stop
		}
	}
}
$global:__zoxide_oldpwd = __zoxide_pwd
function global:__zoxide_hook {
	$result = __zoxide_pwd
		if ($result -ne $global:__zoxide_oldpwd) {
			if ($null -ne $result) {
				zoxide add "--" $result
			}
			$global:__zoxide_oldpwd = $result
		}
}
$global:__zoxide_hooked = (Get-Variable __zoxide_hooked -ErrorAction SilentlyContinue -ValueOnly)
if ($global:__zoxide_hooked -ne 1) {
	$global:__zoxide_hooked = 1
		$global:__zoxide_prompt_old = $function:prompt

		function global:prompt {
			if ($null -ne $__zoxide_prompt_old) {
				& $__zoxide_prompt_old
			}
			$null = __zoxide_hook
		}
}
function global:__zoxide_z {
	if ($args.Length -eq 0) {
		__zoxide_cd ~ $true
	}
	elseif ($args.Length -eq 1 -and ($args[0] -eq '-' -or $args[0] -eq '+')) {
		__zoxide_cd $args[0] $false
	}
	elseif ($args.Length -eq 1 -and (Test-Path $args[0] -PathType Container)) {
		__zoxide_cd $args[0] $true
	}
	else {
		$result = __zoxide_pwd
			if ($null -ne $result) {
				$result = __zoxide_bin query --exclude $result "--" @args
			}
			else {
				$result = __zoxide_bin query "--" @args
			}
		if ($LASTEXITCODE -eq 0) {
			__zoxide_cd $result $true
		}
	}
}
function global:__zoxide_zi {
	$result = __zoxide_bin query -i "--" @args
		if ($LASTEXITCODE -eq 0) {
			__zoxide_cd $result $true
		}
}


# ===========================================================
# YAZI
# ===========================================================
function ra {
	$tmp = [System.IO.Path]::GetTempFileName()
		yazi $args --cwd-file="$tmp"
		$cwd = Get-Content -Path $tmp -Encoding UTF8
		if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
			Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
		}
	Remove-Item -Path $tmp
}
# ===========================================================
# UNIX-LIKE COMMAND
# ===========================================================
Set-Alias -Name which -Value Get-Command

function open {
	param (
			[string]$Path
		  )

		if ([string]::IsNullOrEmpty($Path)) {
			$Path = "."
		}
	if (-not (Test-Path -Path $Path)) {
		Write-Error "指定的路径不存在: $Path"
			return
	}
	Start-Process $Path
}
function ll{
	ls -l
}

function vf {
	$tar = fd -t f | fzf
	if (-not [string]::IsNullOrEmpty($tar)) {
		nvim $tar
	}
}
function zf {
	$tar = fd -t f | fzf
	$tar = dirname "$tar"
	if (-not [string]::IsNullOrEmpty($tar)) {
		Set-Location -Path $tar
	}
}
function zd {
	$tar = fd -t d | fzf
	if (-not [string]::IsNullOrEmpty($tar)) {
		Set-Location -Path $tar
	}
}
# function touch {
#     param (
#         [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
#         [string[]]$input_Paths
#     )

# 	foreach($einput in $input_Paths)
# 	{
# 		$Paths = Expand-Braces $einput
# 		foreach ($path in $Paths) {
# 			# 检查文件是否存在
# 			if (-not (Test-Path -Path $path)) {
# 				# 文件不存在，创建新文件
# 				New-Item -ItemType File -Path $path
# 			}
# 		}
# 	}
# }

# function rm {
#     param (
#         [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
#         [string[]]$input_Paths,

# 		[Parameter()]
# 		[switch]$rf,

#         [Parameter()]
#         [switch]$r,

#         [Parameter()]
#         [switch]$f

#     )

# 	foreach($eachinput in $input_Paths) {
# 		$Paths = Expand-Braces $eachinput
# 		foreach ($path in $Paths) {
# 			# 检查路径是否存在
# 			if (Test-Path -Path $path) {
# 				# 构建 Remove-Item 命令的参数
# 				$params = @{
# 					Path = $path
# 				}
# 				if ($rf) {
# 					$r = $true
# 					$f = $true
# 				}

# 				if ($r) {
# 					$params.Recurse = $true
# 				}
# 				if ($f) {
# 					$params.Force = $true
# 					$params.Confirm = $false
# 				}

# 				# 执行删除操作
# 				Remove-Item @params
# 				Write-Host "Removed: $path"
# 			} else {
# 				Write-Host "Path not found: $path" -ForegroundColor Yellow
# 			}
# 		}
# 	}
# }

# function Expand-Braces {
#     param (
#         [string]$inputString

#     # 正则表达式匹配花括号内的内容
#     $pattern = '\{([^}]+)\}'
#     $matches = [regex]::Matches($inputString, $pattern)

#     # 存储所有可能的组合
#     $combinations = @($inputString)

#     foreach ($match in $matches) {
#         $newCombinations = @()
#         $options = $match.Groups[1].Value -split ','
#         foreach ($option in $options) {
#             foreach ($combination in $combinations) {
#                 $newCombination = $combination -replace [regex]::Escape($match.Value), $option
#                 $newCombinations += $newCombination
#             }
#         }
#         $combinations = $newCombinations
#     }

#     return $combinations
# }

# function ln {
# 	param (
# 		[Parameter()]
# 		[switch]$sf,

# 		[Parameter()]
# 		[switch]$s,

# 		[Parameter()]
# 		[switch]$f,

# 		[Parameter(Mandatory = $true, Position = 0)]
# 		[string]$Source,

# 		[Parameter(Mandatory = $true, Position = 1)]
# 		[string]$Link
# 	)
# 	if ($sf) {
# 		$f = $true
# 		$s = $true
# 	}
	
# 	if (Test-Path -Path $Source) {
# 		if ((Test-Path -Path $Link) -and $f) {
# 			Remove-Item $Link
# 		}
# 		if (-not (Test-Path -Path $Link)) {
# 			if($s) {
# 				New-Item -ItemType SymbolicLink -Path $Link -Target $Source
# 			} else {
# 				New-Item -ItemType HardLink -Path $Link -Target $Source
# 			}
# 		} else {
# 			Write-Host "ERROR: File exists, please remove the file or use -f" -ForegroundColor Yellow
# 		}
# 	} else {
# 		Write-Host "ERROR: Source file not found" -ForegroundColor Yellow
# 	}
# }

# function Generate-Combinations {
#     param (
#         [array]$lists
#     )

#     # 递归生成所有组合
#     function Generate-Combinations-Recursive {
#         param (
#             [array]$lists,
#             [array]$current,
#             [int]$index
#         )

#         if ($index -eq $lists.Count) {
#             $result += ,$current
#             return
#         }

#         foreach ($item in $lists[$index]) {
#             $newCurrent = $current + $item
#             Generate-Combinations-Recursive $lists $newCurrent ($index + 1)
#         }
#     }

#     $result = @()
#     Generate-Combinations-Recursive $lists @() 0
#     return $result
# }

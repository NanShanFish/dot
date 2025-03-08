function gcp
  if test (count $argv) -ne 1
    echo "Usage: gcp <repository>"
    return 1
  end

  git clone --depth=1 https://www.ghproxy.cn/$argv[1]
end

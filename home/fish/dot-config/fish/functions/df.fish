function df
    df -h -x tmpfs -x efivarfs | awk '!/^dev/'
end

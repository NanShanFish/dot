function df
    command df -h -x tmpfs -x efivarfs | sed '/^dev/d; /^none/d'
end

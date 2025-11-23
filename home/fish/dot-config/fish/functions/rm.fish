function rm
    echo "rm was forbidden"
    read -P 'use mm instead? [y/N] ' -l confirm
    switch $confirm
        case y Y
            mm $argv
        case '*'
            echo 'Operation canceled.'
    end
end

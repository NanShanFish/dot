function mm
    set -f total (count $argv)
    set -f cnt 0
    set -f time (date +%m%d-%H:%M)

    for f in $argv
        if test -e $f
            set -f fb (string replace --all "/" "%%" (realpath $f))
            printf "\r%d/%d:%s" $cnt $total $f >&2
            mv $f "$TRASH/$fb.$time"
            set cnt (math $cnt + 1)
        else
            set_color red; echo -e "\nERROR: $f not exists"; set_color normal
        end
    end
    printf "\r%d/%d" $cnt $total
end

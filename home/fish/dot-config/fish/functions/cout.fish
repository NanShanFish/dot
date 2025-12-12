function cout
    if test "$XDG_SESSION_TYPE" = "wayland"
        wl-paste
    else
        xclip -selection clipboard -out
    end
end

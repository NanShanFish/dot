set -U fish_greeting ""

fish_add_path --append ~/.local/bin ~/.cargo/bin ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/

###  ENVIRONMENT VARIABLES  ###
set -Ux EDITOR /bin/nvim
set -Ux BROWSER /bin/vivaldi-stable
set -Ux XDG_DOWNLOAD_DIR "$HOME/dls"
set -Ux XDG_DOCUMENTS_DIR "$HOME/doc"
set -gx LANG "zh_CN.UTF-8"
# set -Ux DWM "$HOME/dot/extra/dwm"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
# pnpm end

## My Archlinux dotfiles

This is a collection of my personal configuration files ("dotfiles") for Arch Linux, which help customize and manage my system's behavior and appearance.

```
.
├── extra/                          # Manually compiled software and additional browser configurations
│   ├── dwm/                        # Source code for the Dynamic Window Manager (dwm)
│   ├── st/                         # Source code for the simple terminal (st)
│   └── vivaldi/                    # Custom Vivaldi browser styles (user.css) and Stylus import settings
├── home/                           # User-specific configuration files
│   ├── alacritty/
│   ├── bin/                        # Directory for custom shell scripts and personal commands
│   │   ├── dot-local/              # Scripts intended for `~/.local/bin/`
│   │   │   └── bin/
│   │   │       └── jy              # Opens the journal entry for the corresponding date
│   │   └── scr/                    # Main script directory
│   │       ├── bluetooth.sh        # Manages Bluetooth devices using rofi (switch, connect, disconnect)
│   │       ├── blurlock.sh         # A visually appealing blur-effect screen locker using i3lock
│   │       ├── color.sh            # Defines color variables for use by other scripts
│   │       ├── convert.sed         # A sed script for removing Chinese punctuation marks
│   │       ├── hibernate.sh        # Handles system hibernation, with a check for kernel updates
│   │       ├── indent_tree.sh      # Generates a tree structure based on the indentation level of input
│   │       ├── light.sh            # Adjusts screen brightness
│   │       ├── markdown_TOC.sh     # Generates a table of contents from Markdown headings
│   │       ├── renew_year_event.py # Updates annual events based on date, converts to lunar calendar
│   │       ├── rofi.sh             # Launches frequently used commands via rofi
│   │       ├── todo.sh             # Displays the to-do list
│   │       └── vol.sh              # Controls audio volume
│   ├── dunst/
│   ├── fastfetch/                  # System information tool configuration (Fastfetch)
│   ├── fish/
│   │   └── dot-config/             # Files intended for `~/.config/`
│   │       └── fish/
│   │           ├── completions/    # Fish shell command completions
│   │           │   └── source.fish
│   │           ├── conf.d/         # Configuration snippets loaded on shell startup
│   │           │   └── interactive.fish # Contains shell aliases and fzf configuration
│   │           ├── config.fish     # Sets up PATH and other environment variables
│   │           └── functions/      # Custom Fish shell functions
│   │               ├── df.fish                     # Checks disk usage
│   │               ├── fish_prompt.fish            # Defines the custom shell prompt
│   │               ├── _fzf_complete.fish          # Enhances tab completion using fzf
│   │               ├── _fzf_preview_file.fish
│   │               ├── _fzf_search_directory.fish  # An intuitive file search function using fzf
│   │               ├── _fzf_search_history.fish    # Searches shell history with fzf
│   │               ├── _fzf_wrapper.fish
│   │               ├── gcp.fish                    # Clones Git repositories using a proxy
│   │               ├── mm.fish                     # Safe file deletion (moves files to $TRASH)
│   │               ├── ra.fish                     # Function related to the Yazi file manager
│   │               ├── restore.fish                # Restores files from the trash directory
│   │               ├── __restore_preview.fish
│   │               ├── rm.fish                     # Disables the direct use of `rm`
│   │               └── z.fish                      # Integration for the zoxide directory jumper
│   ├── fontconfig/     # Font configuration and rendering settings
│   ├── git/            # Git configuration (e.g., global .gitconfig)
│   ├── input-gestures/
│   ├── nvim/
│   ├── picom/
│   ├── rofi/
│   ├── snipaste/
│   ├── styleman/      # A simple theme management system written in Python
│   │   ├── dot-config/
│   │   │   └── styleman/
│   │   │       ├── model.toml      # Template configuration file
│   │   │       ├── palette/        # Color scheme files
│   │   │       └── template/       # Template files
│   │   └── dot-local/
│   │       └── bin/
│   │           └── styleman        # The main executable script for theme management
│   ├── tmux/
│   ├── vscode/        # Settings and snippets for Visual Studio Code
│   ├── x11/           # X Window System configuration (e.g., .xinitrc)
│   └── yazi/
├── install.sh         # Main installation script (requires root permissions)
└── root/              # System-wide configuration files (require root access)
    ├── clean-trash    # Cron job or script to clean files older than 6 months from $TRASH monthly
    ├── keyd/          # Key remapping (e.g., Caps Lock to Ctrl, Left Ctrl to Esc)
    └── touchpad/      # System-wide touchpad configuration
```

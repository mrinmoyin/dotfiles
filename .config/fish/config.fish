# source $HOME/.config/themes/colors.fish

# if uwsm check may-start && uwsm select; then
# 	uwsm start default
# end
# if uwsm check may-start; then
# uwsm start hyprland.desktop && hyprlock
# end

set -g fish_greeting

# set fish_color_autosuggestion $onPrimary

export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORM=wayland
#export QT_QPA_PLATFORMTHEME=qt5ct

# export XDG_CONFIG_HOME=/home/notscripter/.config

#starship
starship init fish | source

# export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
# export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel ${_JAVA_OPTIONS}"

# for nix-on-droid
# export PATH="$PATH:/opt/nvim/"
# for arch
# export PATH=$PATH:/home/notscripter/.local/bin
# for fedora
# export PATH=$PATH:/home/notscripter/bin

export DOTFILES=~/dotfiles
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK=/opt/android-sdk
export ANDROID_NDK=/opt/android-ndk
export ANDROID_NDK_HOME=/opt/android-ndk
export NDK_HOME=/opt/android-ndk
# export PATH=/opt/android-sdk/platform-tools/
# export PATH=/opt/android-sdk/tools/bin/
# export PATH=/opt/android-sdk/emulator/
# set -x HOME /opt/android-sdk/platform-tools/
# set -x HOME /opt/android-sdk/tools/bin/
# set -x HOME /opt/android-sdk/emulator/

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# set -U PATH "/opt/xtensa-lx106-elf-gcc/bin"
# set -U PATH /etc/profile.d/xtensa-lx106-elf-gcc.sh

# eval "$(fzf --zsh)"
# eval "$(zoxide init zsh)"

#ESP 
# source /opt/esp-idf/export.fish

# export MDK=$HOME/mdk
# export ARCH=esp32
# export PORT=/dev/ttyUSB0

# Aliases
alias ls='ls --color'
alias la='ls -A --color'
alias n='nvim'
alias c='clear'
alias q='exit'
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias hyprup='sudo pacman -S hyprland hyprutils aquamarine hyprgraphics hyprland-qtutils hyprlang hyprpaper hyprlock xdg-desktop-portal-hyprland hyprcursor hypridle hyprland-qt-support hyprpolkitagent'

alias g='git'
alias gi='g init --object-format=sha256 --initial-branch=main'
alias gs='g status'
alias gc='g checkout'
alias gcb='g checkout -b'
alias gcm='g commit -m'
alias grao='g remote add origin'
alias gcl='g clone'
alias gp='g push'
alias gP='g pull'
alias ga='g add'
alias gaa='g add .'
alias gpo='g push --set-upstream origin'
alias gpom='g push --set-upstream origin main'
alias gpon='g push --set-upstream origin nightly'
alias lg='lazygit'
alias fontup='fc-cache -f /usr/share/fonts/'

# alias aurup 

alias yt='yt-dlp -F'
alias ytd='yt-dlp --embed-metadata --embed-thumbnail'
# alias ytda='yt-dlp --embed-metadata --embed-thumbnail -t aac'
alias ytda='yt-dlp -i -x -f ba -o "%(title)s.%(ext)s" --embed-metadata --embed-thumbnail'
alias ytdv='yt-dlp --embed-metadata --embed-thumbnail -t mkv'
alias ytdp='sh ~/dotfiles/scripts/ytdlp-segment.sh'
alias ytdh='yt-dlp --cookies-from-browser firefox:$HOME/.zen/6t9sh81n.Default\ \(beta\)'

alias bunst='bun start'
alias bunrd='bun run dev'
alias bunrb='bun run build'
alias bunst='bun start'
alias bunra='adb connect 192.168.240.112:5555 && adb -s 192.168.240.112:5555 reverse tcp:8081 tcp:8081 && adb -s 192.168.240.112:5555 reverse tcp:9090 tcp:9090 && adb -s 192.168.240.112:5555 reverse tcp:8787 tcp:8787 && bun run android'
alias gdlc='cd android && ./gradlew clean && cd ..'
alias rninit='bunx @react-native-community/cli@latest init'

alias gr='./gradlew'
alias grun='./gradlew assembleDebug && ./gradlew installDebug'
alias jvmd='killall -9 java'

alias adbcw='adb connect 192.168.240.112:5555 && adb -s 192.168.240.112:5555 reverse tcp:8081 tcp:8081 && adb -s 192.168.240.112:5555 reverse tcp:9090 tcp:9090'

alias ino='arduino-cli'
alias inoc='arduino-cli compile'
alias inou='arduino-cli upload'
alias inor='arduino-cli compile && arduino-cli upload'
alias pde='processing cli'
alias gen-colors='wal -i ~/dotfiles/hypr/background.jpg -n -s --out-dir ~/dotfiles/wal'

alias setwal='~/dotfiles/scripts/setwal.sh'

# alias cbuild="cmake -S . -B build && cmake --build build --target $basename $pwd"
# set bn $basename $pwd
# alias bname="bname is $bn"

# bun completions
# [ -s "/home/notscripter/.bun/_bun" ] && source "/home/notscripter/.bun/_bun"

zoxide init fish | source

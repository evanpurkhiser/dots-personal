#!/usr/bin/env bash

# Dock configuration
defaults write com.apple.dock tilesize -int 24
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock autohide -bool true

# Wipe all dock icons
defaults write com.apple.dock persistent-apps -array

# Disable auto-reordering of desktop spaces
defaults write com.apple.dock mru-spaces -bool false

# Screenshot as png
defaults write com.apple.screencapture type -string "png"

# Finder appearance
defaults write com.apple.finder ShowPathbar -bool false
defaults write com.apple.finder ShowSidebar -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

chflags hidden ~/Movies
chflags hidden ~/Pictures

# Show scrollbars only when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Disable natural scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Don't write ._* files in network shares
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't play sound effects
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Disable click wallaper to show desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Faster key repeat rate
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1         # normal minimum is 2 (30 ms)

# Remove unused apps
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/Keynote.app
sudo rm -rf /Applications/Numbers.app
sudo rm -rf /Applications/Pages.app
sudo rm -rf /Applications/iMovie.app

for app in \
	"cfprefsd" \
	"Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &>/dev/null
done

# Other stuff that needs done
echo "Set hostname with"
echo "-> sudo scutil --set HostName <hostname>"

# Dock configuration
defaults write com.apple.dock tilesize -int 24
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 0;"name" = "DIRECTORIES";}' \
	'{"enabled" = 0;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Wipe all dock icons
defaults write com.apple.dock persistent-apps -array

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
defaults write -g com.apple.swipescrolldirection -bool NO

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Don't write ._* files in network shares
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't play sound effects
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Faster key repeat rate
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1         # normal minimum is 2 (30 ms)

# Reconfigure a number of hotkeys
#
# Useful resources for this
#
#  - https://krypted.com/mac-os-x/defaults-symbolichotkeys/
#  - https://apple.stackexchange.com/questions/201816/how-do-i-change-mission-control-shortcuts-from-the-command-line
SYMBOLIC_KEYS="${HOME}/Library/Preferences/com.apple.symbolichotkeys.plist"

plutil -replace AppleSymbolicHotKeys.52.enabled -bool NO $SYMBOLIC_KEYS  # Turn Dock hiding on/off
plutil -replace AppleSymbolicHotKeys.160.enabled -bool NO $SYMBOLIC_KEYS # Show Launchpad

# Disable default spotlight search (use Raycast instead)
plutil -replace AppleSymbolicHotKeys.64.enabled -bool NO $SYMBOLIC_KEYS
plutil -replace AppleSymbolicHotKeys.65.enabled -bool NO $SYMBOLIC_KEYS

plutil -replace AppleSymbolicHotKeys.33.enabled -bool NO $SYMBOLIC_KEYS  # Application Windows
plutil -replace AppleSymbolicHotKeys.36.enabled -bool NO $SYMBOLIC_KEYS  # Show Desktop
plutil -replace AppleSymbolicHotKeys.118.enabled -bool NO $SYMBOLIC_KEYS # Switch to Desktop 1
plutil -replace AppleSymbolicHotKeys.163.enabled -bool NO $SYMBOLIC_KEYS # Show notification center
plutil -replace AppleSymbolicHotKeys.175.enabled -bool NO $SYMBOLIC_KEYS # Do not disturb
plutil -replace AppleSymbolicHotKeys.222.enabled -bool NO $SYMBOLIC_KEYS # Turn Stage Manager on/off
plutil -replace AppleSymbolicHotKeys.190.enabled -bool NO $SYMBOLIC_KEYS # Quick Note

# Mission Control Super-W
plutil -replace AppleSymbolicHotKeys.32.value.parameters -json '[119, 13, 1966080]' $SYMBOLIC_KEYS

# Move spaces left right Super-[ Super-]
plutil -replace AppleSymbolicHotKeys.79.value.parameters -json '[91, 33, 1966080]' $SYMBOLIC_KEYS
plutil -replace AppleSymbolicHotKeys.81.value.parameters -json '[93, 30, 1966080]' $SYMBOLIC_KEYS

# Apply keyboard changes, the defaults read is needed to ensure the cache is
# primed, then activateSettings does the magic
defaults read com.apple.symbolichotkeys.plist >/dev/null
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

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

echo "Set homebrew autoupdate with"
echo "-> brew autoupdate start 3600 --cleanup"

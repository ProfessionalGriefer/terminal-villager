#!/bin/bash

DESTINATION="$HOME/.local/share/sounds/"

URLS=(
  'https://minecraft.wiki/images/Villager_accept1.ogg?9f1c9&format=original'
  'https://minecraft.wiki/images/Villager_accept2.ogg?6b42a&format=original'
  'https://minecraft.wiki/images/Villager_accept3.ogg?fcf7f&format=original'
  'https://minecraft.wiki/images/Villager_death.ogg?28562&format=original'
  'https://minecraft.wiki/images/Villager_deny1.ogg?9f15d&format=original'
  'https://minecraft.wiki/images/Villager_deny2.ogg?1a1cc&format=original'
  'https://minecraft.wiki/images/Villager_deny3.ogg?a3177&format=original'
  'https://minecraft.wiki/images/Villager_hurt1.ogg?03c12&format=original'
  'https://minecraft.wiki/images/Villager_hurt2.ogg?2f15c&format=original'
  'https://minecraft.wiki/images/Villager_hurt3.ogg?acebe&format=original'
  'https://minecraft.wiki/images/Villager_hurt4.ogg?8b305&format=original'
  'https://minecraft.wiki/images/Villager_idle1.ogg?bfbee&format=original'
  'https://minecraft.wiki/images/Villager_idle2.ogg?98ea5&format=original'
  'https://minecraft.wiki/images/Villager_idle3.ogg?838f1&format=original'
  'https://minecraft.wiki/images/Villager_trade1.ogg?55376&format=original'
  'https://minecraft.wiki/images/Villager_trade2.ogg?3752c&format=original'
  'https://minecraft.wiki/images/Villager_trade3.ogg?f16ca&format=original'
)

mkdir -p "$DESTINATION"

echo "Downloading audio from minecraft.wiki"
curl --progress-bar -C - --location -H "Accept: audio/ogg" -H "Content-Type: audio/ogg" --output-dir "$DESTINATION" --remote-name-all -- "${URLS[@]}"

case "$SHELL" in
*/bash)
  echo 'Appended to ~/.bashrc'
  cat ./script.bash >>~/.bashrc
  ;;
*/zsh)
  echo "Zsh is not supported yet"
  ;;
*/fish)
  echo 'Appended to ~/.config/fish/conf.d/terminal-villager.fish'
  cat ./script.fish >~/.config/fish/conf.d/terminal-villager.fish
  ;;
*/nu)
  echo 'Add the script.nu file manually to your nu config directory'
  ;;
*)
  echo "Unknown shell: $SHELL"
  ;;
esac

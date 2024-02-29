#!/usr/bin/zsh
SwProfile() {
  current=$(cat /sys/firmware/acpi/platform_profile)

  if [[ (! -z $1) && ($current != $1) ]]
  then
    sudo /home/razz1k/.oh-my-zsh/custom/setProfile.sh $1
    current=$(cat /sys/firmware/acpi/platform_profile)
  fi
  
  echo "$current"
}

_SwProfile() {
  compadd "balanced" "low-power" "performance"
}

compdef _SwProfile SwProfile

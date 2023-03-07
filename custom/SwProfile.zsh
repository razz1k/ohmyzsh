#!/usr/bin/zsh
SwProfile() {
  current=$(cat /sys/firmware/acpi/platform_profile)

  if [[ (! -z $1) && ($current != $1) ]]
  then
    sudo bash -c "echo $1 > /sys/firmware/acpi/platform_profile"
    current=$1
  fi
  
  echo "$current"
}

_SwProfile() {
  compadd "balanced" "low-power" "performance"
}

compdef _SwProfile SwProfile

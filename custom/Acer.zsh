#!/usr/bin/zsh
#
# This script is used to set the volume and brightness of the Acer laptop
# It uses ddcutil to set the volume and brightness
# It uses the following commands:
# - ddcutil setvcp 62 20 # set the volume to 20%
# - ddcutil setvcp 62 40 # set the volume to 40%
# - ddcutil setvcp 10 - 10 # decrease the brightness by 10%
# - ddcutil setvcp 10 + 20 # increase the brightness by 20%
# - ddcutil setvcp 10 20 # set the brightness to 20%
# - ddcutil setvcp 10 100 # set the brightness to 100%

Acer() {
  local target sign value

  function usage() {
    echo "Usage: $0 <volume|brightness> <number:0-100>"
  }

  target=$1
  sign=""
  value=""

  if [[ $2 == "+" || $2 == "-" ]]; then
    sign=$2
    value=$3
  else
    value=$2
  fi

  if [ -z "$target" ] || [ -z "$value" ]; then
    usage
    return 1
  fi

  if ! [[ $value =~ ^[0-9]+$ ]]; then
    usage
    return 1
  fi

  case $1 in
    volume)
      ddcutil setvcp 62 $value
      ;;
    brightness)
      if [[ -z $sign ]]; then
        ddcutil setvcp 10 $value
      else
        ddcutil setvcp 10 $sign $value
      fi
      ;;
    *)
      usage
      return 1
      ;;
  esac
}


_Acer() {
  local context state line
  typeset -A opt_args

  # CURRENT is a Zsh variable tracking the position of the cursor in the command line
  case $CURRENT in
    2)
      # Position 1 after the command: suggest the target
      compadd "volume" "brightness"
      ;;
    3)
      # Position 2 after the command: suggest numbers or adjustment signs
      if [[ "$words[2]" == "brightness" ]]; then
        # Brightness allows relative adjustments (+ / -) or literal percentages
        compadd  -V brightness_vals "+" "-" "0" "100" {10..90..10}
      elif [[ "$words[2]" == "volume" ]]; then
        # Volume only expects a literal value (0-100) based on your script logic
        compadd -V volume_vals "0" "100" "50" {10..40..10} {60..90..10}
      fi
      ;;
    4)
      # Position 3 after the command: only happens if position 2 was a "+" or "-"
      if [[ "$words[2]" == "brightness" && ( "$words[3]" == "+" || "$words[3]" == "-" ) ]]; then
        compadd {10..50..10}
      fi
      ;;
  esac
}

compdef _Acer Acer

#!/usr/bin/bash
case $1 in
  balanced)
  ;;
  low-power)
  ;;
  performance)
  ;;
  *)
    exit
  ;;
esac

bash -c "echo $1 > /sys/firmware/acpi/platform_profile"

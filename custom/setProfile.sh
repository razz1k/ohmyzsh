#!/usr/bin/bash
if [[ ! ( ('balanced' == $1) || ('low-power' == $1) || ('performance' == $1) ) ]]; then
  exit
fi

bash -c "echo $1 > /sys/firmware/acpi/platform_profile"

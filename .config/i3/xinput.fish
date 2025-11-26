#!/usr/bin/env fish

# Device name, per `xinput`
set -l DEVICES 'Mizar Mouse' 'Mizar Mouse'

# Device type, per `xinput` (check in brackets)
set -l TYPES pointer pointer

# Property name, per `xinput list-props $device`
# First matching property used
set -l PROPS 'Accel Speed' 'Scroll Method Enabled'

# Value to set property to
set -l VALUES -1 '0 0 0'

for i in (seq (count $DEVICES))
  set -l dev $DEVICES[$i]
  set -l type $TYPES[$i]
  set -l prop $PROPS[$i]
  set -l val $VALUES[$i]

  set -l id (xinput | grep $dev | grep $type)
  set -l id (string match -r 'id=([0-9]+)' $id[1])[2]

  set -l num (xinput list-props $id | grep $prop)
  set -l num (string match -r '\(([0-9]+)\)' $num[1])[2]

  echo xinput set-prop $id $num $val
  xinput set-prop $id $num $val
end

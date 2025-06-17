#!/usr/bin/env fish

set -l DEVICES 'Mizar Mouse' 'Mizar Mouse'
set -l TYPES pointer pointer
set -l PROPS 'Accel Speed' 'Scroll Method Enabled'
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

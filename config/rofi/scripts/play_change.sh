#!/bin/bash

#echo "$@" >> $HOME/selection_log

#if [[ -n "$@" ]]; then 
    #killall espeak
    #echo "selected: $@" | sed -e 's/<span.*<\/span>//g' | espeak
    coproc aplay -q /home/mat/Programs/rofi-desktop/scripts/sounds/current/change.wav
#fi

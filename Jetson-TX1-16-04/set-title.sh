#!/bin/bash

cat <<EOT >> ~/.bashrc

# function to set terminal title
function title(){
  if [[ -z "\$ORIG" ]]; then
    ORIG="\$PS1"
  fi
  TITLE="\[\e]2;\$*\a\]"
  PS1="\${ORIG}\${TITLE}"
}

EOT


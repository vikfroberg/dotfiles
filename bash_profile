if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

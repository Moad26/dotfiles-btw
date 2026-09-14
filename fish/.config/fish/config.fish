if status is-interactive
  set -g fish_greeting
  set -g fish_key_bindings fish_hybrid_key_bindings

  abbr -a ls 'eza --color --icons --group-directories-first'
  abbr -a ll 'eza -la --icons --group-directories-first'
  abbr -a v 'nvim'
  abbr -a c 'clear'
  abbr -a cat 'bat'
  abbr -a k 'kubectl'

  bind \cp up-or-search
  bind \cn down-or-search

  if type -q fzf
        # Custom options still apply to the plugin
        set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"
  end
  #
  # if type -q zoxide
  #       zoxide init fish | source
  #   end
  # set -U tide_async false
  # starship init fish | source
end
#
# # Go
# fish_add_path /usr/local/go/bin
# fish_add_path $HOME/go/bin
# fish_add_path ~/.config/scripts
# # # Pyenv
# # set -gx PYENV_ROOT $HOME/.pyenv
# # if test -d "$PYENV_ROOT/bin"
# #     fish_add_path "$PYENV_ROOT/bin"
# # end
# # if type -q pyenv
# #     pyenv init - | source
# # end
#
# # Local bin
# fish_add_path $HOME/.local/bin
# fish_add_path $HOME/.config/emacs/bin
#
# set -Ux JAVA_HOME /usr/lib/jvm/java-21-openjdk
# set -Ux SCALA_HOME /usr/bin/scala
# set -gx DOCKER_BUILDKIT 1
# set -gx COMPOSE_DOCKER_CLI_BUILD 1
# set -gx PATH $PATH $HOME/.krew/bin
# if test -f "$HOME/.local/bin/env"
#     bass source "$HOME/.local/bin/env"
# end

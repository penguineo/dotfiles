export CONFIG="$HOME/.config"
export STORAGE="/storage"
export CORE="$CONFIG/shell/core"
export BASH_PLUGINS="$CONFIG/shell/bash/plugins"

# pnpm
export PNPM_HOME="/home/penguineo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# go
export PATH="$HOME/go/bin:$PATH"

# starship
eval "$(starship init bash)"

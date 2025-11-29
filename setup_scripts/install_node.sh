#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/../setup.settings"

echo -e "${CYAN}### Setting up Node.js and npm ###"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# Add NVM initialization to shell configuration file
echo "Adding nvm initialization to $SHELL_CONFIG_FILE..."
{
    echo 'export NVM_DIR="$HOME/.nvm"'
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
} >> "$SHELL_CONFIG_FILE"

# download and install Node.js
nvm install 20
echo -e "${CYAN} Node version $(node -v)"
echo -e "${CYAN} npm version $(npm -v)"

# Install typescript and eslint support
npm i -g typescript
npm i -g vscode-langservers-extracted
npm i -g @vue/language-server

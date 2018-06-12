#!/bin/bash

set -e

# Delegate to the dotfiles repo
curl -L https://raw.githubusercontent.com/lbergnehr/dotfiles/master/install_dotfiles.sh | bash

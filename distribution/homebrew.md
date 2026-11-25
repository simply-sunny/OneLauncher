# Install OneClient with Homebrew

If you installed OneClient from a DMG, quit it and move `OneClient.app` out of `/Applications` before installing the cask.

```sh
brew tap polyfrost/oneclient https://github.com/Polyfrost/OneLauncher.git
brew install --cask polyfrost/oneclient/oneclient
```

The cask installs the signed OneClient app for Apple Silicon or Intel. OneClient can update itself. To update it through Homebrew, run:

```sh
brew update
brew upgrade --cask polyfrost/oneclient/oneclient
```

Quit OneClient before uninstalling it with Homebrew.

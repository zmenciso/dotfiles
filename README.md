#   Dotfiles
These are my personal configuration files, all contained in a single repository
for ease of copying and backup.

##  NeoVim
NeoVim plugin customization is handled with the `vim-plug` plugin manager,
which can be installed with:

```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Copy `.vim` as well as `.config/nvim/init.vim` for quick setup.

##  Language Support
Install `fcitx-mozc`, and copy the `.pam_environment` file into the home directory.
For QT-based configuration, install `kcm-fcitx`.
  - NEologd significantly improves conversion prediction (search the AUR for
      `fcitx-mozc-neologd-ut`, or the binary version).

##  Power Management
If running on a laptop, consider installing `powertop` or `TLP`.  Details are
abundant on the Arch Wiki.

##  Plasma
Use the `plasma_settings.py` script to import or export Plasma settings to the
dotfiles repo.
```
./plasma_settings.py [options] [import/export] CATEGORY
-q --quiet      Suppress verbose output
-i --interact   Interactive (Manually approve each copy)
-h --help       Print this message

Categories:
    all
    panel
    appearance
    workspace
    personalization
    hardware

Import: Copy files from the system to the dotfiles repo
Export: Copy files from the dotfiles repo to the system

This script only works when placed in the `scripts` directory in the dotfiles repo!''')
```
### Appearance
  - Plasma colors and themes are [Aritim Dark](https://github.com/Mrcuve0/Aritim-Dark)
  - Window decorations are [Sierra Breeze](https://github.com/ishovkun/SierraBreeze)

### Layout, Widgets, etc.
... should all be imported from the relevant dotfiles

### SDDM
Install `sddm-kcm` for the KDE config module.  In it, SDDM theme and other settings
can be synchronized to Plasma settings.

### Unlock KDE Wallet Automatically
Install `kwallet-pam` for the PAM compatible module.  The chosen KWallet password
must be the same as the current user password.  No further configuration should
be necessary for use with SDDM.

##  Code
Aritim Dark can be manually added to Code with the `Aritim-Code.jsonc` file.

### Extensions
  - C/C++
  - Code Spell Checker
  - LaTeX Workshop
  - Power Mode
  - Python
  - Remote - SSH
  - Verilog HDL/SystemVerilog
  - **Vim**

##  KDE Config File Paths
### Panel
`.config/plasma-org.kde.plasma.desktop-appletsrc`

### Appearance
  - Global Theme
    - `.config/kdeglobals`
    - `.config/kscreenlockerrc`
    - `.config/kwinrc`
    - `.config/gtkrc`
    - `.config/gtkrc-2.0`
    - `.config/gtk-4.0/*`
    - `.config/gtk-3.0/*`
    - `.config/ksplashrc`
  - Application Style: `.config/kdeglobals`
  - Plasma Style: `.config/plasmarc`
  - Colors
    - `.config/kdeglobals`
    - `.config/Trolltech.conf`
  - Window decorations
    - `.config/breezerc`
    - `.config/kwinrc`
  - Fonts
    - `.config/kdeglobals`
    - `.config/kcmfonts`
  - Icons: `.config/kdeglobals`
  - Cursors: `.config/kcminputrc`
  - Font Management: `.config/kfontinstuirc`
  - Splash screen: `.config/ksplashrc`

### Workspace
  - Desktop Behavior
    - `.config/plasmarc`
    - `.config/kwinrc`
    - `.config/kglobalshortcutsrc`
  - Window Management
    - `.config/kwinrc`
    - `.config/kwinrulesrc`
  - Shortcuts
    - `.config/khotkeys`
    - `.config/kglobalshortcutsrc`
  - Startup and Shutdown
    - `.config/kded5rc`
    - `.config/ksmserverrc`
  - Search
    - `.config/krunnerrc`
    - `.config/baloofilerc`

### Personalization
  - Notifications: `.config/plasmanotifyrc`
  - Regional Settings
    - `.config/plasma-localerc`
    - `.config/ktimezonedrc`
  - Accessibility: `.config/kaccessrc`
  - User Feedback: `.config/PlasmaUserFeedback`

### Network
  - Connections: `/etc/NetworkManager/system-connections`

### Hardware
  - Keybooard
    - `.config/kcminputrc`
    - `.config/kxkbrc`
  - Gamma: `.config/kgammarc`
  - Power Management: `.config/powermanagementprofilesrc`
  - Bluetooth: `.config/bluedevilglobalrc`
  - KDE Connect: `.config/kdeconnect`
  - Removable Storage:
    - `.config/device_automounter_kcmrc`
    - `.config/kded5rc`
    - `.config/kded_device_automounterrc`



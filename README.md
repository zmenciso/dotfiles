#   Dotfiles

These are my personal configuration files, all contained in a single repository
for ease of copying and backup.

Use the `settings.py` script to import or export settings to/from the dotfiles
repo:

```
scripts/settings.py [options] [import/export] CATEGORY
    -q --quiet      Suppress verbose output
    -i --interact   Interactive (Manually approve each copy)
    -h --help       Print this message

    Categories (or 'all'):
        ...

    Import: Copy files from the system to the dotfiles repo
    Export: Copy files from the dotfiles repo to the system

    This script only works when placed in the `scripts` directory in the dotfiles repo!
```

##  Hyprland

It is recommended to install Hyprland after installing another DE like GNOME,
since these configs use some GTK system utilities, applications, and themes.

Requires:
  - `hyprland`
  - `waybar-hyprland-git`
  - `rofi-wayland`
  - `swaylock`
  - `swayidle`
  - `swaync`
  - `hyprpaper`
  - `alacritty`
  - `xsettingsd`
  - `papirus-icon-theme`

Edit `/usr/share/wayland-sessions/hyprland.desktop` to exec `.wrappedhl` instead
of `Hyprland` so environment variables are set properly.

Font: **BlexMono Nerd Font** (contained in dotfiles repo)

Theme: [**Orchis Dark Compact (Black
Tweak)**](https://github.com/cyko-themes/gtk-orchis) (contained in dotfiles
repo)

`lxappearance` is an amazingly convenient tool for setting GTK themes and
cursors without too much hassle.

##  i3-gaps

It is recommended to install i3-gaps after installing another DE like GNOME,
since these configs use some GTK system utilities, applications, and themes.

Requires:
  - `i3-gaps` or `i3-gaps-rounded`
  - `i3lock-color` or `i3lock-fancy` or `i3lock`
  - `xss-lock`
  - `i3status` or `bumblebee-status`
  - `alacritty`
  - `autorandr`
  - `xsettingsd`
  - `dunst`
  - `rofi`
  - `picom`
  - `papirus-icon-theme`
  - `feh`
  - `material-design-icons`

Some additional software is nice to have, like:
  - `xplr`, a CLI file explorer
  - `zathura`, a simple PDF viewer
  - `spotify-tui`, a CLI Spotify client written in Rust (requries `spotifyd`)

Desktop entries for these programs are included in `.desktop`.  They can be
installed with:

```
desktop-file-install --dir=/usr/share/applications [FILE]
```

The colors are based on
[`vim-moonfly-colors`](https://github.com/bluz71/vim-moonfly-colors).

##  NeoVim

NeoVim plugin customization is handled with the [`vim-plug` plugin
manager](https://github.com/junegunn/vim-plug), which can be installed with:

```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Export `nvim` files, then install plugins.

##  Barrier

Install `barrier`, then perform the following to set up server-side encryption:

```fish
mkdir -p ~/.local/share/barrier/SSL/Fingerprints ;
openssl req -x509 -nodes -days 365 -subj /CN=Barrier -newkey rsa:4096 -keyout \
~/.local/share/barrier/SSL/Barrier.pem -out ~/.local/share/barrier/SSL/Barrier.pem ;
set fingerprint (openssl x509 -fingerprint -sha256 -noout -in \ 
~/.local/share/barrier/SSL/Barrier.pem | cut -d"=" -f2)
echo "v2:sha256:$fingerprint" > ~/.local/share/barrier/SSL/Fingerprints/Local.txt ;
```

##  Chromium

Install `chromium`, then install the following extensions:

  - DuckDuckGo Privacy Essentials
  - uBlock Origin
  - Bitwarden

In addition, set the Theme in "Appearance" to GTK+ and set the option "Ask where
to save each file before downloading" in "Advanced > Downloads".  Bookmarks can
be imported from `goose` (`doc/Miscellaneous/bookmarks*`).

##  Language Support

### i3-gaps

Install `ibus-mozc`, export `mozc` files, and load `ibus` settings from `dconf`
with the following command:

```
dconf load /desktop/ibus/ < ~/dotfiles/ibus-dconf-dump
```

For more accurate conversions, use the UT dictionary for Mozc (available as the
`mozc-ut` flavor on the AUR).

In addition, edit `/etc/environment` to include the following:

```
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
```

### Budgie/GNOME

Since `ibus` is tightly integrated with GTK, install `ibus-mozc` and export
`mozc` files.  Restart or log out before before loading the dconf settings
below.

### Plasma

Install `fcitx-mozc`, and export `fcitx` files. For QT-based configuration,
install `kcm-fcitx`.
  - NEologd significantly improves conversion prediction (search the AUR for
    `fcitx-mozc-neologd-ut`, or the binary version).

##  Budgie

In addition to exporting `budgie`, use `dconf` to dump and load
`/com/solus-project/`, `/org/gnome/`, and `/net/launchpad/plank/docks/`.

```
dconf load /com/solus-project/ < ~/dotfiles/budgie-dconf-dump
dconf load /net/launchpad/plank/docs/ < ~/dotfiles/plank-dconf-dump
dconf load /org/gnome/ < ~/dotfiles/gnome-dconf-dump
```

##  GNOME

Install `pop-shell`, then use `dconf` to load `/org/gnome/`.

##  Power Management

If running on a laptop, consider installing `powertop` or `TLP`.  Details are
abundant on the Arch Wiki.

##  Microsoft Office (via Wine)

First install `wine` and `winetricks`, then boot the wine instance with
`wineboot -i` and allow it to install anything it needs to.  Then install some
additional tools with winetricks:

```
winetricks cmd corefonts gdiplus riched20
```

Afterwards, set the Windows version in Wine from 7 to 10 using `winecfg`, then
install Office:

```
wine /path/to/OfficeSetup.exe
```

##  Plasma

**Note: As of 2022-04-21, Plasma-related settings have been deprecated and
removed from the target list.**

Export `panel`, `appearance`, `workspace`, `personalization`, and `hardware`.

### Appearance
  - Plasma colors and themes are [Aritim Dark](https://github.com/Mrcuve0/Aritim-Dark)
  - Window decorations are [Lightly](https://github.com/Luwx/Lightly)

### Layout, Widgets, etc.
... should all be imported from the relevant dotfiles

### SDDM
Install `sddm-kcm` for the KDE config module.  In it, SDDM theme and other settings
can be synchronized to Plasma settings.

### Unlock KDE Wallet Automatically
Install `kwallet-pam` for the PAM compatible module.  The chosen KWallet password
must be the same as the current user password.  No further configuration should
be necessary for use with SDDM.

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



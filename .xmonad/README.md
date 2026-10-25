# Standalone xmonad with KDE appearance

Choose the `xmonad` X11 session in SDDM. With these dotfiles installed in your
home directory, SDDM sources `.xprofile` before starting xmonad. The profile
selects KDE's Qt platform theme, starts `~/.local/bin/xmonad-kde-settings`, and
sets the root wallpaper using the embedded one-pixel PNG and `xloadimage`.

On Arch, install the runtime dependencies:

```sh
sudo pacman -S --needed python kconfig plasma-integration dbus xsettingsd xorg-xrandr xorg-xrdb xorg-xset xloadimage
```

Keep the packages providing your selected KDE widget style, icons and cursors
installed too. The bridge uses your existing KDE configuration; it does not
hardcode a theme or scale, modify KDE's saved settings, or start Plasma/KWin.

KDE applications read their colors, widget style, fonts and icons through
`QT_QPA_PLATFORMTHEME=kde`, including defaults selected by KDE's global theme.
The bridge publishes scaling and font-rendering settings through X resources
and XSETTINGS, and sends KDE's appearance-change notifications when settings
change. It checks the saved files and connected displays every two seconds.
For example, a saved 175% scale becomes 168 DPI without multiplying it by a
second Qt scale factor. Running Qt 6 widgets can resize when the scale changes;
applications that cache their settings may need to be reopened.

Scale settings are read in this order:

1. `kdeglobals`: `[KScreen] ScaleFactor` (the saved Plasma X11 global scale).
2. `kdeglobals`: `[KScreen] ScreenScaleFactors` for connected outputs.
3. `kwinoutputconfig.json`: saved output scales, matching connected outputs
   where connector names agree between X11 and Wayland.
4. `kwinrc`: `[Xwayland] Scale`.
5. `kcmfonts`: `[General] forceFontDPI`.
6. 100% when no scaling override has been saved.

This deliberately preserves the saved X11 scale when both X11 and Wayland
settings exist. Changing only a lower-priority setting does not override it.
All active monitors must use the same scale. Mixed or malformed values are
reported in the log; after startup, the last successfully applied settings
remain active until the configuration is corrected.

The watcher manages one `xsettingsd` process per display. Do not separately
autostart another XSETTINGS manager in this session. Existing settings from
`~/.xsettingsd` or `~/.config/xsettingsd/xsettingsd.conf` are preserved except
for the DPI, font-rendering and cursor keys managed by the bridge.

To inspect the applied scale from the xmonad session:

```sh
~/.local/bin/xmonad-kde-settings --status
```

The log is `~/.local/state/xmonad/kde-settings.log` (or under `$XDG_STATE_HOME`
when set). Startup failures also appear in SDDM's X11 session log. The watcher
exits when its XSETTINGS connection closes at logout, and repeated `--start`
calls do not create duplicate watchers.

# Vanadium SystemWebView

Magisk / KernelSU module that installs [Vanadium WebView](https://github.com/grapheneos/vanadium)
as a selectable WebView provider next to the stock one, and keeps the Vanadium browser up to date
with the module.

## Requirements

- arm64, Android 14+
- Magisk, KernelSU or APatch
- KernelSU: a metamodule (`meta-overlayfs` or similar)

## Install

```bash
adb push VanadiumSystemWebView-*.zip /data/local/tmp/
adb shell su -c "ksud module install /data/local/tmp/VanadiumSystemWebView-*.zip"
adb reboot
```

Then select **Vanadium WebView** in *Developer options → WebView implementation*.
The stock WebView is kept, so removing the module reverts everything.

The module also installs and updates the Vanadium browser. To turn that off, press the module's
**Action** button in the root manager (it toggles `browser_disabled`; takes effect on next boot).
The WebView provider itself is always managed by the module.

## Builds

The workflow runs daily and on manual dispatch. It takes the newest GrapheneOS commit that
changed the Vanadium APK, downloads both APKs and **verifies the signature** against
`CN=GrapheneOS`. A build fails if the APK is not signed by them.

Hashes are computed at build time and written into `module.prop`; `customize.sh` verifies them on
the device, so a tampered zip is rejected at install. The same hashes are listed in the release
notes.

If a release for the source commit already exists, the run exits without rebuilding.

## Credits

Vanadium is developed by the GrapheneOS Project. This module is unofficial and not supported by
them — do not report issues with it upstream.

Module scripts and CI: MIT (see `LICENSE`). Vanadium: GPL-2.0 and Chromium licenses.

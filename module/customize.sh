#!/system/bin/sh

ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print "  Vanadium SystemWebView"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

WV_APK="$MODPATH/system/app/webview/webview.apk"
CFG_APK="$MODPATH/system/app/VanadiumConfig/VanadiumConfig.apk"
OVL_APK="$MODPATH/system/product/overlay/VanadiumWebViewProviderOverlay.apk"

[ -f "$WV_APK" ] || abort "! ERROR: webview.apk not found in module"
[ -f "$CFG_APK" ] || abort "! ERROR: VanadiumConfig.apk not found in module"
[ -f "$OVL_APK" ] || abort "! ERROR: VanadiumWebViewProviderOverlay.apk not found in module"

check_sha() {
    label="$1"
    file="$2"
    expected="$3"
    if [ -z "$expected" ] || ! command -v sha256sum >/dev/null 2>&1; then
        ui_print "! $label: sha256 not verified"
        return 0
    fi
    actual="$(sha256sum "$file" | cut -d' ' -f1)"
    if [ "$actual" != "$expected" ]; then
        abort "! ERROR: $label sha256 mismatch (expected $expected, got $actual)"
    fi
    ui_print "- $label sha256 ok"
}

check_sha webview.apk "$WV_APK" "$(grep '^webviewSha256=' "$MODPATH/module.prop" | cut -d= -f2)"
check_sha VanadiumConfig.apk "$CFG_APK" "$(grep '^configSha256=' "$MODPATH/module.prop" | cut -d= -f2)"

BR_APK="$MODPATH/browser/VanadiumBrowser.apk"
if [ -f "$BR_APK" ]; then
    check_sha VanadiumBrowser.apk "$BR_APK" "$(grep '^browserSha256=' "$MODPATH/module.prop" | cut -d= -f2)"
fi

ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH/system/app/webview" 0 0 0755 0644
set_perm "$WV_APK" 0 0 0644

if command -v chcon >/dev/null 2>&1; then
    chcon u:object_r:system_file:s0 "$WV_APK" 2>/dev/null || true
    chcon u:object_r:system_file:s0 "$CFG_APK" 2>/dev/null || true
    chcon u:object_r:system_file:s0 "$OVL_APK" 2>/dev/null || true
fi

ui_print "- Done. Reboot to apply."

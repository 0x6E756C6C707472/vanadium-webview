#!/system/bin/sh

MODDIR=${0%/*}

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 5
done

sleep 5

if [ "$(settings get global webview_provider)" != "app.vanadium.webview" ]; then
    cmd webviewupdate set-webview-implementation app.vanadium.webview
fi

BROWSER_APK="$MODDIR/browser/VanadiumBrowser.apk"

if [ -f "$BROWSER_APK" ]; then
    WANT="$(grep '^browserVersion=' "$MODDIR/module.prop" | cut -d= -f2)"
    HAVE="$(dumpsys package app.vanadium.browser 2>/dev/null | sed -n 's/.*versionName=//p' | head -n1)"
    if [ -n "$WANT" ] && [ "$WANT" != "$HAVE" ]; then
        pm install -r "$BROWSER_APK"
    fi
fi

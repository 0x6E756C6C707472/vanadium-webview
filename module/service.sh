#!/system/bin/sh

MODDIR=${0%/*}

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 5
done

sleep 5

if [ "$(settings get global webview_provider)" != "app.vanadium.webview" ]; then
    cmd webviewupdate set-webview-implementation app.vanadium.webview
fi

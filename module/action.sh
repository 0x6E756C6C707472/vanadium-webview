#!/system/bin/sh

MODDIR=${0%/*}
FLAG="$MODDIR/browser_disabled"

if [ -f "$FLAG" ]; then
    rm -f "$FLAG"
    echo "Browser auto-install: ON"
else
    touch "$FLAG"
    echo "Browser auto-install: OFF"
fi

echo ""
echo "Takes effect on the next boot."

# explicitly specify no dynamic linker if we're not doing dynamic linking,
# even if e.g. the cc-wrapper has passed through a previous -dynamic-linker
# flag for some reason. lld in particular needs to be told this to stop it
# setting an interpreter field.

if [[ "$linkType" != dynamic ]]; then
    extraAfter+=(
        '-no-dynamic-linker'
    )
fi

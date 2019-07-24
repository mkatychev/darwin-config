#!/usr/bin/env bash
# https://color.firefox.com/?theme=XQAAAAIUAQAAAAAAAABBqYhm849SCia2CaaEGccwS-xNKlhVwOfxYkvKRy7XZEEKOMA_2dkd8ZwCj0CEXlCZNTXhAq5rPX2cmPVooHRSotDOD2Q0TC-qnuH0Hwb4Bb4RjqIH4kM2SozG03qapjW7gpxyrtopM0drbQ8PbQpkRGygkPGEM4ls2xJaxLqK5V4jN6d1iisAnId0XPEYZW82lVpzZVLKcshx7GZVOxn-vn8DJrTheidqoA6RDrZSqv7A4H6QOr9NktCOz_03yJp5tzYKzYK-X_00msA
for i in $HOME/Library/Application\ Support/Firefox/Profiles/*; do
  if [ -d "$i" ]; then
    mkdir -p "$i/chrome"
    cp $HOME/.config/usr_tools/firefox_settings/userChrome.css "$i/chrome"
  fi
done

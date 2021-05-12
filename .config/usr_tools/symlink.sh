#!/usr/bin/env bash

RECTANGLE_PLIST="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"

link_rectangle() {
  ln -s "$tool/prefs/com.knollsoft.Rectangle.plist" "$RECTANGLE_PLIST"
}

rm "$RECTANGLE_PLIST"; link_rectangle

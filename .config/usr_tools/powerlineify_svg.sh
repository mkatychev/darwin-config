#!/bin/bash
 
# https://github.com/chmln/sd
# brew install rustup-init && cargo install sd
# https://sourcefoundry.org/hack/
cdn_uri="https://cdn.jsdelivr.net/npm/hack-font@3.3.0/build/web/hack.css"
font_name="Hack"
function powerlineify(){
   sd -i \
       "(<style type=\"text/css\".+>)" \
       "\${1}@import url(\"$cdn_uri\");" "$1"
   sd -i \
       "(font-family: ?)(['\"][\w ]+['\"])(.+;)" \
       "\${1}'$font_name'\${3}" "$1"
}
powerlineify "$1"

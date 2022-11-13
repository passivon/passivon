#!/usr/bin/env bash

echo "Oneliner installation"

pkg update && pkg install ruby
wget -qO- https://raw.githubusercontent.com/passive-english/passive-english/main/install2.rb | ruby

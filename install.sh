#!/usr/bin/env bash

echo "Oneliner installation"

pkg update
pkg install -y ruby
wget -qO- https://raw.githubusercontent.com/passivon/passivon/main/install2.rb | ruby

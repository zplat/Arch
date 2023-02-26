#!/usr/bin/env bash 

cd "$HOME/.local/repositories"

git clone https://github.com/riverwm/river.git

cd river
git submodule update --init
zig build -Drelease-safe -Dxwayland --prefix ~/.local install

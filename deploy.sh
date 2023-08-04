#!/usr/bin/env bash
nix-build
scp -r result/* lanny@lannysport.net:/opt/lannysport

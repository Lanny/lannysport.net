#!/usr/bin/env bash
make
scp -r build/* lanny@lannysport.net:/opt/lannysport

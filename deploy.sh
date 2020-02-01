#!/usr/bin/env bash
make
scp -r build/* lannysport.net:/opt/lannysport

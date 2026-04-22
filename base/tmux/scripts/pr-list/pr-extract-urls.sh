#!/usr/bin/env bash
# Extract PR URLs from fzf multi-select output (tab-delimited, first field is URL)
# Reads from stdin, outputs one URL per line
grep -o 'https://github.com/[^	]*'

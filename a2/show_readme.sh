#!/bin/bash
pandoc -s -f markdown -t plain ./README.md | less

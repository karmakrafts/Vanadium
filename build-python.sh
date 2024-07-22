#!/bin/bash

#
# Copyright (C) 2024 Karma Krafts & associates
#

cp "src/main/antlr/FerrousLexer.g4" "vanadium"
cp "src/main/antlr/FerrousParser.g4" "vanadium"

java -jar "tools/antlr-4.13.1-complete.jar" -Dlanguage=Python3 "vanadium/FerrousLexer.g4"
java -jar "tools/antlr-4.13.1-complete.jar" -Dlanguage=Python3 "vanadium/FerrousParser.g4"

python3 -m build
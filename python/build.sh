#!/bin/bash

cp ../src/main/antlr/*.g4 .
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 FerrousLexer.g4
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 FerrousParser.g4
python3 -m build
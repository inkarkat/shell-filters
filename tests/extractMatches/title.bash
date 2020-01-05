#!/bin/bash

case "$TERM" in
    screen*)
	readonly R=']2;['
	readonly N=']\'
	;;
    *)
	readonly R=']2;['
	readonly N=']'
	;;
esac

readonly SIMPLE_INPUT="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."

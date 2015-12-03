#!/bin/bash

tput setaf 1; echo this is red
tput setaf 2; echo this is green
tput bold; echo "boldface (and still green)"
tput sgr0; echo back to normal

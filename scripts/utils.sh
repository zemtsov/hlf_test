#!/bin/bash

COLOR_RESET='\033[0m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[1;33m'

timestamp() {
  date +%Y-%m-%d' '%H:%M:%S
}

function println() {
  echo -e "$1"
}

function title() {
  echo
  LENGTH=${#1}
  U_LINE=$(head -c "${LENGTH}" < /dev/zero | tr '\0' '=')
  println "${COLOR_GREEN}${U_LINE}${COLOR_RESET}"
  println "${COLOR_GREEN}${1}${COLOR_RESET}"
  println "${COLOR_GREEN}${U_LINE}${COLOR_RESET}"
}

function error() {
  println "${COLOR_RED}$(timestamp) ${1}${COLOR_RESET}"
}

function success() {
  println "${COLOR_GREEN}$(timestamp) ${1}${COLOR_RESET}"
}

function info() {
  println "${COLOR_BLUE}$(timestamp)${COLOR_RESET} ${1}"
}

function warning() {
  println "${COLOR_YELLOW}$(timestamp) ${1}${COLOR_RESET}"
}

function fatal() {
  error "$1"
  exit 1
}

export -f error
export -f success
export -f info
export -f warning
export -f fatal
export -f title
#!/usr/bin/env bash

__parallel_context=""
__parallel_task=""
__parallel_tagstring=""

function context() {
  __parallel_context="$@"
}

function tag() {
  __parallel_tagstring="$@"
}

function async() {
  if [ -n "$__parallel_tagstring" ]; then
    parallel --semaphore --lb --tag --tagstring \
      "$(eval echo $__parallel_tagstring)" \
      $__parallel_context "$@"
  else
    parallel --semaphore --lb $__parallel_context "$@"
  fi
}

function await() {
  if [ $# -ne 0 ]; then
    if [ -n "$__parallel_tagstring" ]; then
      parallel --lb --tag --tagstring "$(eval echo $__parallel_tagstring)" \
        $__parallel_context "$@"
    else
      parallel --lb $__parallel_context "$@"
    fi
  else
    parallel --semaphore --wait
  fi
  __parallel_tagstring=""
}

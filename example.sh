#!/usr/bin/env bash

dir=$(dirname $0)
. $dir/parallel.sh

# execution context
context --jobs 5

# asynchronous tasks and wait
for a in $(seq 10); do
  tag "[task $a]"
  async $dir/longtask.sh "$a"
done
await

# wait on asynchronous task
tag "[task {1}]"
await $dir/longtask.sh "{1}" ::: $(seq 10)

#!/bin/bash
vault=$1
item=$2

op item get --vault $vault $item --format json | \
  jq -r \
    '.fields | 
      map(select(.label == ".env")) | 
      first | 
      .value'

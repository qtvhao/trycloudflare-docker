#!/bin/bash

set -xeo pipefail
bash /app/get-tunnel.sh "$1" "$2" "$3" 2>/tmp/get-tunnel.log

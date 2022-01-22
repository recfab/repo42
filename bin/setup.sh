#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

apt install -y \
  jq

curl -1sLf 'https://dl.cloudsmith.io/public/evilmartians/lefthook/setup.deb.sh' | bash
apt install lefthook

npm install -g cspell

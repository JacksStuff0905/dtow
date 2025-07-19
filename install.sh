#!/bin/bash

trg="${1:-/usr/local/bin/dtow}"
src="$(dirname "$0")/dtow"

echo -e "Installing dtow to $trg..."
echo -e "\nCopying $src to $trg..."
if sudo cp $src $trg; then
  echo -e "\nDone."
else
  echo -e "\nFailed."
fi


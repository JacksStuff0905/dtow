#!/bin/bash

trg="${1:-/usr/local/bin/dtow}"

echo -e "Uninstalling dtow from $trg..."
echo -e "\nRemoving $trg..."

if sudo rm $trg; then
  echo -e "\nDone."
else
  echo -e "\nFailed."
fi

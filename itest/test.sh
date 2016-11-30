#!/bin/bash
set -e

DISTRIBUTION=`cat /etc/*-release | grep DISTRIB_CODENAME | awk -F= '{print $2}'`

cd /

LATEST=$(ls -1 /osquery/osquery/build/$DISTRIBUTION/osquery_*.deb | head -n1)

if dpkg -i $LATEST; then
  echo "Looks like it installed correctly"
else
  echo "Dpkg install failed"
  exit 1
fi

# Copy the example config and try and start the osqueryd service to ensure a good package.
cp /usr/share/osquery/osquery.example.conf /etc/osquery/osquery.conf
osqueryctl start

exit $?

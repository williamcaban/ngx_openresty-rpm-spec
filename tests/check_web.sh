#!/bin/bash
# Based on: Website status checker.
# Adapted from work by ET (etcs.me)
# Based on isOnline: https://github.com/ET-CS/isOnline
# Original source https://raw.githubusercontent.com/ET-CS/isOnline/master/checker.sh

# Set `Quiet` true when using in scripts
# Set `Quite` false to show output when run interactively at shell
QUIET=false

function test_url {
  response=$(curl --write-out %{http_code} --silent --output /dev/null $1)
  filename=$( echo $1 | cut -f1 -d"/" )
  if [ "$QUIET" = false ] ; then echo -n "$p "; fi

  if [ $response -eq 200 ] ; then
    # website working
    if [ "$QUIET" = false ] ; then
      echo -n "$response "; echo -e "\e[32m[ok]\e[0m"
    fi
    # remove .temp file if exist 
    if [ -f $TEMPDIR/$filename ]; then rm -f $TEMPDIR/$filename; fi
  else
    # website down
    if [ "$QUIET" = false ] ; then echo -n "$response "; echo -e "\e[31m[DOWN]\e[0m"; fi
    if [ ! -f $TEMPDIR/$filename ]; then
        echo "$p WEBSITE DOWN" "$1 WEBSITE DOWN ( $response )"
        echo > $TEMPDIR/$filename
        exit 1
    fi
  fi
}

# We only need to check if the service is running
test_url $1

#
# END OF FILE
#
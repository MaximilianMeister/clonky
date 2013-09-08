#!/bin/bash

#set -x

my_name=${0##*/}

hours="$1"

if test -z "$hours"
then echo "Usage: $my_name hours [minutes] [message]" 1>&2
     exit 1
fi

case "$hours" in
     [0-1][0-9] | 2[0-3] ) ;;
     [0-9] ) hours="0$hours" ;;
     * ) echo "'$hours' : Not a valid hour ( 0 - 23 )" 1>&2
         exit 1 ;;
esac

case "$2" in
     [0-9] | [0-5][0-9] ) minutes="$2"
                          shift 2
                          message="$*" ;;
     * ) shift 1
         message="$*"
         minutes="" ;;
esac

if test -z "$minutes"
then echo "Enter minutes (random input or timeout after 10 seconds set minutes to 0): "
     read -t 10 minutes
     case "$minutes" in
          [0-9] | [0-5][0-9] ) ;;
          * ) minutes="0" ;;
     esac
fi

case "$minutes" in
     [0-5][0-9] ) ;;
     [0-9] ) minutes="0$minutes" ;;
     * ) echo "'$minutes' : Not a valid minute ( 0 - 59 )" 1>&2
         exit 1 ;;
esac 

alarm_time="$hours$minutes"

echo "At $hours:$minutes you get the xmessage $message"

background_stuff()
{ while true
  do current_time=$( date +%H%M )
     if test "$current_time" -ge "$alarm_time"
     then break
     fi
     sleep 30
  done
  xmessage -nearmouse -timeout 18000 "$hours:$minutes $message"
  exit 0
}

background_stuff &

exit 0


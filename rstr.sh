#!/bin/bash

usage()
{
        echo "replaceStr <pattern> <new pattern>"
}

filerep()
{
        for i in $(grep -ril $1 *); do sed "s/$1/$2/g" "$i" > tmp && \mv tmp "$i"; done
}

if [ -z "$1" ]; then
        echo "It need the first argument."
        usage
elif [ -z "$2" ]; then
        echo "It need the second argument."
        usage
else
        if test "$1" && test "$2"
        then
                filerep $1 $2
        fi
fi

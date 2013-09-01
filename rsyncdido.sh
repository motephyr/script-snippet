#!/bin/bash
# --exclued=*.svn
rsync -av --exclude=*.bak --exclude tool/ --exclude sql/ --exclude WEB-INF/classes/ --exclude html/ /dido mote@www.nextun.com:/tmp

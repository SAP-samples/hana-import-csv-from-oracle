#!/bin/bash

##########################################################################
# Copyright 2021 SAP SE or an SAP affiliate company
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

# The following values are passed from Oracle when the
# external job is started.  The driving variable is the
# fileGUID - this prefixes all the files.
localDir=$1
fileGUID=$2
remoteHost=$3
remoteUser=$4
remoteDir=$5

# All files are found at the localDir
filePrefix=$localDir/$fileGUID

# Build all the file names we need.
csvFile=$filePrefix.csv
sqlFile=$filePrefix.sql
zipFile=$filePrefix.zip
logFile=$filePrefix.log

# Some quick and dirty logging tools so we can generate
# log entries - the log is retrieved later and stored
# in the logging table.
verbosity=4 # default to show warnings

silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
inf_lvl=4
dbg_lvl=5

notify()   { log $silent_lvl "NOTE    : $1"; } # Always prints
critical() { log $crt_lvl    "CRITICAL: $1"; }
error()    { log $err_lvl    "ERROR   : $1"; }
warn()     { log $wrn_lvl    "WARNING : $1"; }
inf()      { log $inf_lvl    "INFO    : $1"; } # "info" is already a command
debug()    { log $dbg_lvl    "DEBUG   : $1"; }

log() {
    if [ $verbosity -ge $1 ]; then
        datestring=$(date +'%Y-%m-%d %H:%M:%S')

        # Expand escaped characters, wrap at 70 chars, indent wrapped lines
        echo -e "$datestring $2" >> $logFile
    fi
}

inf "Starting zip and ship of $fileGUID"

# The Oracle DB has asked us to ship and load this
# file to the HANA server.  Start by zipping
# the file and then remove the original.

csvFileSize=$(du $csvFile)
inf "File size $csvFileSize"

inf "Starting zip $csvFile"
zip -j $zipFile $csvFile $sqlFile >> $logFile
inf "Completed zip $csvFile"

inf "Remove $csvFile and $sqlFile"
rm -f $csvFile $sqlFile

# Now ship the file to the HANA box - this step
# assumes we have setup password-less login to
# the HANA box.

inf "Starting scp to $remoteUser@$remoteHost:$remoteDir/exports"
scp -v $zipFile $remoteUser@$remoteHost:$remoteDir/exports >> $logFile
inf "Completed scp to $remoteUser@$remoteHost:$remoteDir/exports"

inf "Removing zip file"
rm -f $zipFile

# Note: this process launch the csv_launch.sh script on the HANA
# server.  This script starts a background job to do the load
# and exits - this means this script can exit and return control
# to the Oracle server.

inf "Launch remote script using ssh $remoteDir/csv_launch.sh"
ssh $remoteUser@$remoteHost "$remoteDir/csv_launch.sh $fileGUID && exit"

inf "Done."

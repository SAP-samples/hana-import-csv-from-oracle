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

# The following path must match the path specified when
# the extract job was created - THIS SHOULD NOT BE HARDCODED.

loaderPath=/usr/sap/HXE/HDB90/csv-loader
logFile=$loaderPath/csv_loader.log
exportPath=$loaderPath/exports

# This is the same guid used to create, zip and ship
# this table to the HANA server.

fileGUID=$1
timestamp=$(date)

echo "$timestamp - Start loading $fileGUID" >> $logFile

cd $loaderPath/exports

# The remote server provides 2 files for each table.  The zip
# is the actual CSV (zipped).  The SQL file has the HANA create
# table and import statements.
zipFile=$fileGUID.zip
sqlFile=$fileGUID.sql

# Durint this script, we'll extract the CSV to the following file
# and record logging information to the HDB file.  Note: the GUID for
# a table does not change between runs so the HDB file is the log
# for the most recent load of this table.
csvFile=$fileGUID.csv
hdbFile=$fileGUID.hdb

echo "$timestamp - Unziping $zipFile" >> $logFile

unzip $zipFile
rm -f $zipFile

timestamp=$(date)
echo "$timestamp - Unzip of $zipFile complete." >> $logFile

# The hardcoded password should be changed.
echo "$timestamp - Starting hdbsql for $sqlFile..." >> $logFile
hdbsql -i 90 -u csvadm -p Welcome01 -quiet -f -o $hdbFile -m -I $sqlFile

timestamp=$(date)
echo "$timestamp - Complete hdbsql for $sqlFile..." >> $logFile

echo "$timestamp - Removing $csvFile and $sqlFile." >> $logFile
rm -f $csvFile $sqlFile

echo "$timestamp - Complete load for $fileGUID." >> $logFile

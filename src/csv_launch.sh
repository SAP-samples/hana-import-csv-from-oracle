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

# This script is invoked by the remote host to launch a background
# job in the SAP HANA operating system.  Using the nohup command
# allows this script to exit and returns control back to the source
# database immediately.

# The following path must match the path specified when
# the extract job was created - THIS SHOULD NOT BE HARDCODED.
loaderPath=/usr/sap/HXE/HDB90/csv-loader
logFile=$loaderPath/csv_loader.log

fileGUID=$1
timestamp=$(date)

echo "$timestamp - Received $fileGUID" >> $logFile

# Launch the actual load as a detached background job.  This
# releases the SSH shell from the Oracle server immediately.

nohup $loaderPath/csv_loader.sh $fileGUID >/dev/null 2>&1 &

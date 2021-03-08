# CSV from Oracle

## Description
This tool uses features of the SAP HANA and Oracle databases to move tables from Oracle to SAP HANA as flat files, i.e., CSV.

To better visualize the entires process, this flowchart hightlights some of the major processing steps:

## Requirements
This project was developed and tested using Oracle RDBMS 12c and SAP HANA 2 SPS05.  To successfully run this project, the Oracle instance must be configured to allow access to operating system to both create files using UTL_FILE and execute scripts.

## Download and Installation
The files listed below are used mostly in the order they appear.  Please note that you will need to make adjustments to directories and databases schemas to match your environment.

### Getting started

| File | Description |
| ---- | ----------- |
| Flow.png | This is a detailed view of the major control elements of the process.|
| create-user.txt | Grants needed in the Oracle and HANA databases.  Also includes links to useful links.|
| create-tables.sql | Create the tables supporting the process.|

### Installing the software

| File | Description |
| ---- | ----------- |
CSV_EXPORTER.pls | Oracle package specification.
CSV_EXPORTER.plb | Oracle package body.
csv_exporter.sh | Linux script placed on the Oracle server to zip-n-ship the CSV output for a table.
csv_launch.sh | Linux script on the HANA server that is call by the csv_exporter.sh to start a HANA import.
csv_loader.sh | Linux script on the HANA server to perform the HANA import.

### Running tests

| File | Description |
| ---- | ----------- |
| sample-job.sql | Example of building and running an export of a schema. |
| stop-job.sql | Example of stopping a running job. |
| load-blob-from-oracle-dir.sql | Quick script to load a BLOB to test exporting to CSV. |
| build-data.sql | Example script to create 100 tables to export with 150K to 1M rows per table. |

## Known Issues

## How to obtain support

[Create an issue](https://github.com/SAP-samples/<repository-name>/issues) in this repository if you find a bug or have questions about the content.
 
For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## Contributing

## License
Copyright (c) 2021 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.

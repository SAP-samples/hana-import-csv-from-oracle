# SAP HANA import CSV files from Oracle

## Description
This proof of concept uses features of both SAP HANA and Oracle databases to move tables from Oracle to SAP HANA as flat files, i.e., CSV.  To achieve the best possible performance, the tool create many threads to export tables to CSV, move them to the SAP HANA platform, and load them into an SAP HANA schema.

To better visualize the entires process, this flowchart hightlights some of the major processing steps:

![Process Flow](images/flow.png?raw=true "Process Flow")

After a job is created, a job is started using the process in section 1.  This routine starts as many threads in the Oracle database as defined in the job - these are processed in step 2.  Each thread is 100% asynchronous.  Once started, each thread automatically re-submits itself until all tables have been processed.

The process in step 2 is the job orchistrator that determines if all tables have been exported and if the job has been terminated.  When tables remain, a new job is started to obtain and process the next available table - step 3.

Step 3 describes the main processing life-cycle of a single table.  The most important step from a job control standpoint is the locking of the job table.  This ensures this thread/job has exclusive control of the job metadata, all other threads wait until the lock is released.  Once a table is identified it is exported to a CSV file to a directory specified when the job was created (sufficient disk space is required).

To keep everything asynchronous, after the CSV file is complete, a new DBMS_SCHEDULER job is created to run the compress/transfer script at the operating system.  The last step in the job executes a remote SSH session to run the import scripts into the SAP HANA instance.

Steps 4 and 5 are clean-up jobs that constantly scan for and load log files generated by the operating system scripts.

## Requirements
* This project was developed and tested using Oracle RDBMS 12c and SAP HANA 2 SPS05.
* Proper schema privileges must be granted to database users in both platforms.
* To successfully run this project, the Oracle instance must be configured to allow access to operating system to both create files using UTL_FILE and execute scripts.
* The SSH between the Oracle host and the SAP HANA host must be configured for certificate authentication - passwords must NOT be required.

Details may be found in the [create-users.txt](src/create-users.txt) file.

## Download and Installation
The files listed below are used mostly in the order they appear.  Please note that you will need to make adjustments to directories and databases schemas to match your environment.

### Getting started

| File | Description |
| ---- | ----------- |
| flow.png | This is a detailed view of the major control elements of the process.|
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
There are no known issues.

## How to obtain support
This code is provided "as-is" with no expected changes or support.  Questions or comments should be directed directly to [Mark Greynolds](mailto:mark.greynolds@sap.com?subject=Oracle CSV exporter&body=Question or comment on the Orace CSV to SAP HANA export tool).

## Contributing
This project is only updated by SAP employees and accepts no other contributions.

## License
Copyright (c) 2021 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.

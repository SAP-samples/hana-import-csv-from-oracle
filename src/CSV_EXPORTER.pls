/*
##########################################################################
Copyright 2021 SAP SE or an SAP affiliate company

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
##########################################################################
*/

create or replace package  csv_exporter as
    -- This is the fully qualified name of the exporter script
    -- used to run the zip-n-ship process.  The Oracle directory
    -- must exist pointing to this location.
    csv_exporter_script varchar2(2000) := '/home/oracle/csv_exporter.sh';
    csv_exporter_shell  varchar2(2000) := '/bin/bash';
    
    -- Create a new job with the Oracle/HANA connectivity information.
    procedure create_job(in_job_name       varchar2,
                         in_oracle_dir     varchar2,
                         in_threads        integer default 1,
                         in_remote_host    varchar2,
                         in_remote_dir     varchar2,
                         in_remote_user    varchar2,
                         in_hana_user      varchar2,
                         in_hana_schema    varchar2);

    -- Utility function to add all the visible tables in a schema
    -- to a job.
    procedure add_schema(in_job_name   varchar2,
                         in_schema     varchar2);
                      
    -- Utility function to add a single table to a job - a job can
    -- pull from multiple schemas.
    procedure add_table(in_job_name    varchar2,
                        in_schema      varchar2,
                        in_table       varchar2);

    -- Start a job running.                        
    procedure run_job(in_job_name varchar2);
    
    -- Cancel a job - the job stops when all threads
    -- complete the operation (table dump) in progress.
    procedure stop_job(in_job_name varchar2);
    
    -- Remove a job.
    procedure drop_job(in_job_name varchar2);

    -- Private methods used by DBMS_SCHEDULER - do not call directly
    procedure export_table(in_job_name varchar2, in_thread integer);
    procedure get_script_log(in_job_name varchar2, in_table_guid varchar2);
end csv_exporter;
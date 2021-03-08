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

drop table csv_exporter_log;
drop table csv_exporter_jobs;
drop table csv_exporter_tables;

-- Logging table so jobs can be monitored and errors are captured.
create table csv_exporter_log (
    cel_timestamp    timestamp default systimestamp,
    cel_scope        varchar2(200),
    cel_level        varchar2(200),
    cel_message      clob);

-- A job is defines the from and to details on the Oracle and HANA platforms.
-- Last run statistics are also recorded.
create table csv_exporter_jobs (
    cej_name            varchar2(200) primary key,
    cej_oracle_dir      varchar2(200),
    cej_threads         integer,
    cej_remote_host     varchar2(400),
    cej_remote_dir      varchar2(400),
    cej_remote_user     varchar2(400),
    cej_hana_user       varchar2(400),
    cej_hana_schema     varchar2(400),
    cej_status          varchar2(400),
    cej_start_ts        timestamp,
    cej_end_ts          timestamp,
    cej_elapsed         integer,
    cej_table_count     integer,
    cej_row_count       integer);

-- For each job, an explicit list of tables is maintained.  At the
-- start of a job, all the statuses are set to Pending.  When there
-- are no more Pending tables, the job stops.
create table csv_exporter_tables (
    cet_name            varchar2(200),
    cet_schema          varchar2(200),
    cet_table           varchar2(200),
    cet_status          varchar2(200),
    cet_thread          integer,
    cet_estimated_rows  integer,
    cet_row_count       integer,
    cet_start_ts        timestamp,
    cet_end_ts          timestamp,
    cet_elapsed         integer,
    cet_guid            varchar2(32),
    cet_script_log      clob);  
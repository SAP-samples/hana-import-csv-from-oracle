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

declare
  job_name csv_exporter_jobs.cej_name%type := 'Move RDBMS Data';
BEGIN
  -- Make it easier to review the logs...
  
  delete from csv_exporter_log;
  commit;
  
  -- Create/re-create the job - implicit drop.
  
  CSV_EXPORTER.create_job(
    in_job_name      => job_name,
    in_oracle_dir    => 'LOADER_DIR',  /* Target Oracle "CREATE DIRECTORY" directory for CSV/SQL files */
    in_threads       => 4,             /* Should be less than physical cores */
    in_remote_host   => 'exporter.hana.sizingtool.us',  /* Target HANA host */
    in_remote_dir    => '/usr/sap/HXE/HDB90/loader',    /* Landing zone for CSV - ../exports added */
    in_remote_user   => 'hxeadm',      /* SSH/SCP user - no password required */
    in_hana_user     => 'csvadm',      /* HANA technical user doing the imports (**needs work**)*/
    in_hana_schema   => 'TARGET_SCHEMA /* Target schema in HANA */
  );
  
  -- Add all visible tables (SELECT privilege) from the SOURCE_SCHEMA schema.
  
  CSV_EXPORTER.add_schema(job_name, 'SOURCE_SCHEMA');
  
  -- Kick off the job.  Future runs for the same job/tables only require this call to run_job.
    
  CSV_EXPORTER.run_job(job_name);
END;

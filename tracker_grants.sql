grant select on tracker_logs to public;
/

grant select on tracker_log_changes to public;
/

/*
-- GRANT FOR THE USER WHERE THE tracker PACKAGE WILL BE INSTALLED
grant create any trigger to &user;
/
grant drop any trigger to &user;
/
grant alter any trigger to &user;
/
grant select on dba_objects to &user;
/
grant select on dba_indexes to &user;
/
grant select on dba_ind_columns to &user;
/
grant select on dba_constraints to &user;
/
grant select on dba_tab_columns to &user;
/
grant create any trigger to &user;
/
*/

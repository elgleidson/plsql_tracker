create or replace view auditor_log_changes as
select 
  al.audit_id, 
  al.audit_date,
  al.table_owner,
  al.table_name,
  al.row_simple_key,
  al.row_keys,
  rc.col_name,
  rc.old_value,
  rc.new_value,
  al.os_user,
  al.host,
  al.module,
  al.action,
  al.audit_callstack
from auditor_logs al, table(al.row_changes) rc;
/


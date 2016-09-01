create or replace view tracker_log_changes as
select 
  al.tracking_id, 
  al.tracking_date,
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
  al.tracking_callstack
from tracker_logs al, table(al.row_changes) rc;
/


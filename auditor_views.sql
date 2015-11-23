create or replace view v_auditor_logs as
select 
  al.audit_date, 
  al.table_owner, 
  al.table_name,
  auditor.get_data(al.row_key) as row_key,
  al.audit_id, 
  al.column_name, 
  auditor.get_data(al.old_value) as old_value,
  auditor.get_data(al.new_value) as new_value,
  al.audit_info
from auditor_logs al;
/


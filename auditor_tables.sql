create table auditor_configs (
  table_owner      varchar2(30) not null,
  table_name       varchar2(30) not null,
  table_keys       varchar2(4000) not null,
  include_columns  clob,
  exclude_columns  clob,
  trigger_name     varchar2(30) not null,
  exception_stmt   clob,
  -- 
  enabled          char(1) not null,
  start_audit      timestamp default current_timestamp not null,
  stop_audit       timestamp,
  -- 
  constraint auditor_configs_pk primary key (table_owner, table_name)
);
/

create sequence seq_auditor_logs;
/


create table auditor_logs (
  audit_id         number not null,
  audit_date       timestamp default current_timestamp not null,
  table_owner      varchar2(30) not null,
  table_name       varchar2(30) not null,
  row_simple_key   varchar2(4000),
  row_keys         auditor_columns,
  row_changes      auditor_column_changes,
  -- 
  os_user          varchar2(100),
  host             varchar2(100),
  module           varchar2(100),
  action           varchar2(100),
  audit_callstack  varchar2(4000)
) 
nested table row_keys store as auditor_logs_row_keys, 
nested table row_changes store as auditor_logs_row_changes
;
/

create index auditor_logs_idx_date on auditor_logs(audit_date, table_owner, table_name);
/

create index auditor_logs_idx_key on auditor_logs(table_owner, table_name, row_simple_key);
/

create index auditor_logs_row_keys_idx on auditor_logs_row_keys(nested_table_id, col_name, col_value);
/

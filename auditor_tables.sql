create table auditor_logs (
  audit_id         number not null,
  audit_date       timestamp default current_timestamp not null,
  table_owner      varchar2(30) not null,
  table_name       varchar2(30) not null,
  row_key          anydata not null,
  column_name      varchar2(30) not null,
  old_value        anydata, 
  new_value        anydata,
  -- 
  audit_callstack  varchar2(4000),
  audit_info       varchar2(500) not null,
  -- 
  constraint auditor_logs_pk primary key (table_owner, table_name, column_name, audit_id)
);
/

create index auditor_logs_idx_date on auditor_logs(audit_date, table_owner, table_name, column_name);

create sequence seq_auditor_logs;
/

create table auditor_configs (
  table_owner      varchar2(30) not null,
  table_name       varchar2(30) not null,
  table_key        varchar2(30) not null,
  exclude_columns  clob,
  trigger_name     varchar2(30) not null,
  -- 
  enabled          char(1) not null,
  start_audit      timestamp default current_timestamp not null,
  stop_audit       timestamp,
  -- 
  constraint auditor_configs_pk primary key (table_owner, table_name)
);
/
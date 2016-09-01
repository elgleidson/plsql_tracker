create table tracker_configs (
  table_owner      varchar2(30) not null,
  table_name       varchar2(30) not null,
  table_keys       varchar2(4000) not null,
  include_columns  clob,
  exclude_columns  clob,
  trigger_name     varchar2(30) not null,
  exception_stmt   clob,
  -- 
  enabled          char(1) not null,
  start_tracking   timestamp with time zone default current_timestamp not null,
  stop_tracking    timestamp with time zone,
  -- 
  constraint tracker_configs_pk primary key (table_owner, table_name)
);
/

create sequence seq_tracker_logs;
/


create table tracker_logs (
  tracking_id         number not null,
  tracking_date       timestamp with time zone default current_timestamp not null,
  table_owner         varchar2(30) not null,
  table_name          varchar2(30) not null,
  row_simple_key      varchar2(4000),
  row_keys            tracking_columns,
  row_changes         tracking_column_changes,
  -- 
  os_user             varchar2(100),
  host                varchar2(100),
  module              varchar2(100),
  action              varchar2(100),
  tracking_callstack  varchar2(4000)
) 
nested table row_keys store as tracker_logs_row_keys, 
nested table row_changes store as tracker_logs_row_changes
;
/

create index tracker_logs_idx_date on tracker_logs(tracking_date, table_owner, table_name);
/

create index tracker_logs_idx_key on tracker_logs(table_owner, table_name, row_simple_key);
/

create index tracker_logs_row_keys_idx on tracker_logs_row_keys(nested_table_id, col_name, col_value);
/

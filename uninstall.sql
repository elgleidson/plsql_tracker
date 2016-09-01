begin
  execute immediate 'drop package tracker';
exception when others then null;
end;
/
begin
  execute immediate 'drop public synonym tracker';
exception when others then null;
end;
/
begin
  execute immediate 'drop table tracker_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop view v_tracker_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop public synonym tracker_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop sequence seq_tracker_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop table tracker_configs';
exception when others then null;
end;
/
begin
  execute immediate 'drop type tracking_columns';
exception when others then null;
end;
/
begin
  execute immediate 'drop type tracking_column';
exception when others then null;
end;
/
begin
  execute immediate 'drop type tracking_column_changes';
exception when others then null;
end;
/
begin
  execute immediate 'drop type tracking_column_change';
exception when others then null;
end;
/

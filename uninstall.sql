begin
  execute immediate 'drop package auditor';
exception when others then null;
end;
/
begin
  execute immediate 'drop public synonym auditor';
exception when others then null;
end;
/
begin
  execute immediate 'drop table auditor_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop view v_auditor_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop public synonym auditor_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop sequence seq_auditor_logs';
exception when others then null;
end;
/
begin
  execute immediate 'drop table auditor_configs';
exception when others then null;
end;
/
begin
  execute immediate 'drop type auditor_columns';
exception when others then null;
end;
/
begin
  execute immediate 'drop type auditor_column';
exception when others then null;
end;
/
begin
  execute immediate 'drop type auditor_column_changes';
exception when others then null;
end;
/
begin
  execute immediate 'drop type auditor_column_change';
exception when others then null;
end;
/

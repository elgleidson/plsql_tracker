create or replace type auditor_column is object (
  col_name     varchar2(30),
  col_value    varchar2(4000)
);
/

create or replace type auditor_columns is table of auditor_column;
/

create or replace type auditor_column_change is object (
  col_name  varchar2(30),
  old_value varchar2(4000),
  new_value varchar2(4000)
);
/

create or replace type auditor_column_changes is table of auditor_column_change;
/

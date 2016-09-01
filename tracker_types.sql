create or replace type tracking_column is object (
  col_name     varchar2(30),
  col_value    varchar2(4000)
);
/

create or replace type tracking_columns is table of tracking_column;
/

create or replace type tracking_column_change is object (
  col_name  varchar2(30),
  old_value varchar2(4000),
  new_value varchar2(4000)
);
/

create or replace type tracking_column_changes is table of tracking_column_change;
/

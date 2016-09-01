create or replace package auditor authid definer as
  
  function generate_audit_trigger(
    p_table_owner    in varchar2, 
    p_table_name     in varchar2, 
    p_trigger_name   in varchar2 default null, 
    p_exception_stmt in clob default null
  ) return clob;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in varchar2);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in number);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in date);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in timestamp);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in timestamp with time zone);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in timestamp with local time zone);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in interval day to second);
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in interval year to month);
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in varchar2, p_new_value in varchar2);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in number, p_new_value in number);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in date, p_new_value in date);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in timestamp, p_new_value in timestamp);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in timestamp with time zone, p_new_value in timestamp with time zone);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in timestamp with local time zone, p_new_value in timestamp with local time zone);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in interval day to second, p_new_value in interval day to second);
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in interval year to month, p_new_value in interval year to month);
  
  procedure start_audit(
    p_table_owner       in varchar2,
    p_table_name        in varchar2,
    p_table_keys        in varchar2 default null,
    p_exclude_columns   in clob default null,
    p_exception_stmt    in clob default null
  );

  procedure stop_audit(
    p_table_owner       in varchar2,
    p_table_name        in varchar2
  );

  procedure refresh_audit(
    p_table_owner       in varchar2,
    p_table_name        in varchar2
  );

  procedure audit_row(
    p_table_owner  in varchar2,
    p_table_name   in varchar2,
    p_row_keys     in auditor_columns,
    p_row_changes  in auditor_column_changes
  );

end;
/

create or replace package body auditor as

  -- TO_STRING
  function to_string(p_value in varchar2) return varchar2
  is
  begin
    return p_value;
  end;
  
  function to_string(p_value in number) return varchar2
  is
  begin
    return to_char(p_value);
  end;
  
  function to_string(p_value in date) return varchar2
  is
  begin
    return to_char(p_value, 'YYYY-MM-DD HH24:MI:SS');
  end;
  
  function to_string(p_value in timestamp) return varchar2
  is
  begin
    return to_char(p_value, 'YYYY-MM-DD HH24:MI:SS.FF9');
  end;
  
  function to_string(p_value in timestamp with time zone) return varchar2
  is
  begin
    return to_char(p_value, 'YYYY-MM-DD HH24:MI:SS.FF9 TZH:TZM');
  end;
  
  function to_string(p_value in timestamp with local time zone) return varchar2
  is
  begin
    return to_char(p_value, 'YYYY-MM-DD HH24:MI:SS.FF9');
  end;
  
  function to_string(p_value in interval day to second) return varchar2
  is
  begin
    return to_char(p_value);
  end;
  
  function to_string(p_value in interval year to month) return varchar2
  is
  begin
    return to_char(p_value);
  end;
  
  
  -- ADD ROW KEY
  procedure append_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in varchar2)
  is
  begin
    p_row_keys.extend;
    p_row_keys(p_row_keys.count) := auditor_column(col_name => upper(p_column_name), col_value => p_column_value);
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in varchar2)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in number)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in date)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in timestamp)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in timestamp with time zone)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in timestamp with local time zone)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in interval day to second)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;
  
  procedure add_row_key(p_row_keys in out nocopy auditor_columns, p_column_name in varchar2, p_column_value in interval year to month)
  is
  begin
    append_row_key(p_row_keys => p_row_keys, p_column_name => p_column_name, p_column_value => to_string(p_column_value));
  end;

  
  -- ADD ROW CHANGE
  procedure append_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in varchar2, p_new_value in varchar2)
  is
  begin
    p_row_changes.extend;
    p_row_changes(p_row_changes.count) := auditor_column_change(col_name => upper(p_column_name), old_value => p_old_value, new_value => p_new_value);
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in varchar2, p_new_value in varchar2)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in number, p_new_value in number)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in date, p_new_value in date)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in timestamp, p_new_value in timestamp)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in timestamp with time zone, p_new_value in timestamp with time zone)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in timestamp with local time zone, p_new_value in timestamp with local time zone)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in interval day to second, p_new_value in interval day to second)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  procedure add_row_change(p_row_changes in out nocopy auditor_column_changes, p_column_name in varchar2, p_old_value in interval year to month, p_new_value in interval year to month)
  is
  begin
    append_row_change(p_row_changes => p_row_changes, p_column_name => p_column_name, p_old_value => to_string(p_old_value), p_new_value => to_string(p_new_value));
  end;
  
  
  function get_call_stack return varchar2
  is
  begin
    return dbms_utility.format_call_stack;
  end;
  

  function generate_trigger_name(p_table_owner in varchar2, p_table_name in varchar2) return varchar2
  is
    v_object_id number;
  begin
    select object_id
    into v_object_id
    from dba_objects
    where object_type = 'TABLE'
    and owner = upper(p_table_owner)
    and object_name = upper(p_table_name);

    return 'AUD$'||v_object_id;
  end;
  
  
  function get_table_column_changes(p_table_owner in varchar2, p_table_name in varchar2) return clob
  is
    v_changes           clob;
    v_exclude_columns   clob;
  begin
    select exclude_columns
    into v_exclude_columns
    from auditor_configs
    where table_owner = upper(p_table_owner)
    and table_name = upper(p_table_name);  
  
    for cols in (
      select t.column_name
      from dba_tab_columns t
      where t.owner = upper(p_table_owner)
      and t.table_name = upper(p_table_name)
      and t.column_name not in (
        select to_char(regexp_substr(v_exclude_columns, '[^, ]+', 1, level)) as column_name
        from dual
        where regexp_count(v_exclude_columns, '[^, ]+') > 0
        connect by level <= regexp_count(v_exclude_columns, '[^, ]+')
      )
      order by t.column_id
    ) 
    loop
      v_changes := v_changes||'
  auditor.add_row_change(v_changes, '''||cols.column_name||''', :old.'||cols.column_name||', :new.'||cols.column_name||');';
    end loop;
    
    return v_changes;
  end;
  
  
  function get_table_keys(p_table_owner in varchar2, p_table_name in varchar2) return clob
  is
    v_keys              clob;
  begin
    for keys in (
      select to_char(regexp_substr(table_keys, '[^, ]+', 1, level)) as column_name
      from auditor_configs
      where 1 = 1
      and table_owner = upper(p_table_owner)
      and table_name = upper(p_table_name)
      and regexp_count(table_keys, '[^, ]+') > 0
      connect by level <= regexp_count(table_keys, '[^, ]+')
    ) loop
      v_keys := v_keys||'
  auditor.add_row_key(v_keys, '''||keys.column_name||''', :old.'||keys.column_name||');';
    end loop;
    
    return v_keys;
  end;


  function generate_audit_trigger(
    p_table_owner     in varchar2, 
    p_table_name      in varchar2, 
    p_trigger_name    in varchar2 default null, 
    p_exception_stmt  in clob default null
  ) return clob
  is
    v_keys            clob;
    v_changes         clob;
    v_trigger_name    varchar2(30);
  begin
    v_trigger_name := upper(p_trigger_name);
    if v_trigger_name is null then
      v_trigger_name := generate_trigger_name(p_table_owner => p_table_owner, p_table_name => p_table_name);
    end if;
        
    v_changes := get_table_column_changes(p_table_owner => p_table_owner, p_table_name => p_table_name);
    v_keys    := get_table_keys(p_table_owner => p_table_owner, p_table_name => p_table_name);

    return
'create or replace trigger '||v_trigger_name||'
before update on '||upper(p_table_owner)||'.'||upper(p_table_name)||'
for each row
declare
  v_keys       auditor_columns := auditor_columns();
  v_changes    auditor_column_changes := auditor_column_changes();
begin
  '||v_keys||'
  '||v_changes||'
    
  auditor.audit_row('''||p_table_owner||''', '''||p_table_name||''', v_keys, v_changes);
exception when others then 
  '||case when p_exception_stmt is null then 'raise;' else p_exception_stmt end||'
end;';
  end;


  procedure start_audit(
    p_table_owner       in varchar2,
    p_table_name        in varchar2,
    p_table_keys        in varchar2 default null,
    p_exclude_columns   in clob default null,
    p_exception_stmt    in clob default null
  )
  is
    pragma autonomous_transaction;
    v_trigger_name varchar2(30);
    v_trigger      clob;
    v_table_keys   varchar2(4000);
  begin
    v_trigger_name := generate_trigger_name(
      p_table_owner  => p_table_owner,
      p_table_name   => p_table_name
    );

    v_table_keys := upper(p_table_keys);
    if v_table_keys is null then
    begin
      select listagg(cols.column_name, ',') within group (order by null)
      into v_table_keys
      from (
        select row_number() over (order by decode(cons.constraint_type, 'P', 0, 'U', 1, 2)) as rnum, idx.index_name, idx.table_name, idx.owner
        from dba_indexes idx
        left join dba_constraints cons on cons.owner = idx.table_owner and cons.table_name = idx.table_name
        where idx.uniqueness = 'UNIQUE'
        and idx.table_owner = upper(p_table_owner)
        and idx.table_name = upper(p_table_name)
      ) idx
      join dba_ind_columns cols on idx.owner = cols.index_owner and idx.table_name = cols.table_name and idx.index_name = cols.index_name
      where idx.rnum = 1;
    exception
      when no_data_found then
        raise_application_error(-20000, 'Table does not have primary key or unique index/constraint!');
    end; 
    end if;
    
    begin
      insert into auditor_configs (table_owner, table_name, table_keys, exclude_columns, trigger_name, enabled, start_audit, stop_audit, exception_stmt)
      values (upper(p_table_owner), upper(p_table_name), v_table_keys, upper(p_exclude_columns), v_trigger_name, 'Y', current_timestamp, null, p_exception_stmt);
    exception when dup_val_on_index then
      update auditor_configs
      set enabled         = 'Y',
          table_keys      = v_table_keys,
          exclude_columns = upper(p_exclude_columns),
          trigger_name    = v_trigger_name,
          start_audit     = current_timestamp,
          stop_audit      = null,
          exception_stmt  = p_exception_stmt
      where table_owner = upper(p_table_owner)
      and table_name = upper(p_table_name);
    end;

    v_trigger := generate_audit_trigger(
      p_table_owner     => p_table_owner,
      p_table_name      => p_table_name,
      p_trigger_name    => v_trigger_name,
      p_exception_stmt  => p_exception_stmt
    );

    execute immediate v_trigger;
    
    commit;
  end;


  procedure stop_audit(
    p_table_owner       in varchar2,
    p_table_name        in varchar2
  )
  is
    pragma autonomous_transaction;
    v_trigger_name varchar2(30);
  begin
    select trigger_name
    into v_trigger_name
    from auditor_configs
    where table_owner = upper(p_table_owner)
    and table_name = upper(p_table_name);

    update auditor_configs
    set enabled    = 'N',
        stop_audit = current_timestamp
    where table_owner = upper(p_table_owner)
    and table_name = upper(p_table_name);

    execute immediate 'drop trigger '||v_trigger_name;
    
    commit;
  exception when no_data_found then
    null;
  end;


  procedure refresh_audit(
    p_table_owner       in varchar2,
    p_table_name        in varchar2
  )
  is
    v_trigger_name   varchar2(30);
    v_trigger        clob;
    v_enabled        char(1);
    v_exception_stmt clob;
  begin
    select trigger_name, upper(t.enabled), exception_stmt
    into v_trigger_name, v_enabled, v_exception_stmt
    from auditor_configs t
    where table_owner = upper(p_table_owner)
    and table_name = upper(p_table_name);

    v_trigger := generate_audit_trigger(
      p_table_owner    => p_table_owner,
      p_table_name     => p_table_name,
      p_trigger_name   => v_trigger_name,
      p_exception_stmt => v_exception_stmt
    );

    execute immediate v_trigger;
    
    if v_enabled <> 'Y' then
      execute immediate 'alter trigger '||v_trigger_name||' disable';
    end if;
  end;


  procedure insert_audit_log(
    p_table_owner   in varchar2,
    p_table_name    in varchar2,
    p_row_keys      in auditor_columns,
    p_row_changes   in auditor_column_changes
  )
  is
    v_call_stack      varchar2(4000);
    v_row_simple_key  varchar2(4000);
  begin
    v_call_stack := get_call_stack();
    
    if p_row_keys.count = 1 then
      v_row_simple_key := p_row_keys(1).col_value;
    end if;
    
    if p_row_changes.count > 0 then
      insert into auditor_logs(
        audit_id,
        audit_date,
        table_owner,
        table_name,
        row_simple_key,
        row_keys,
        row_changes,
        --
        os_user,
        host,
        module,
        action,
        audit_callstack
      ) values (
        seq_auditor_logs.nextval,
        current_timestamp,
        upper(p_table_owner),
        upper(p_table_name),
        v_row_simple_key,
        p_row_keys,
        p_row_changes,
        --
        substr(sys_context('userenv', 'os_user'), 1, 100),
        substr(sys_context('userenv', 'host'), 1, 100),
        substr(sys_context('userenv', 'module'), 1, 100),
        substr(sys_context('userenv', 'action'), 1, 100),
        v_call_stack
      );
    end if;
  end;


  procedure audit_row(
    p_table_owner  in varchar2,
    p_table_name   in varchar2,
    p_row_keys     in auditor_columns,
    p_row_changes  in auditor_column_changes
  )
  is
    v_changes    auditor_column_changes := auditor_column_changes();
  begin
    for i in 1..p_row_changes.count loop
      if not ((p_row_changes(i).old_value is not null 
        and p_row_changes(i).new_value is not null 
        and p_row_changes(i).old_value = p_row_changes(i).new_value
      ) or (p_row_changes(i).old_value is null 
        and p_row_changes(i).new_value is null
      )) then
        add_row_change(v_changes, p_row_changes(i).col_name, p_row_changes(i).old_value, p_row_changes(i).new_value);
      end if;
    end loop;
    
    insert_audit_log(
      p_table_owner   => p_table_owner,
      p_table_name    => p_table_name,
      p_row_keys      => p_row_keys,
      p_row_changes   => v_changes
    );    
  end;

end;
/

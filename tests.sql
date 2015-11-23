drop table teste;
create table teste (id number, valor_inteiro number, valor_float float, flag char(1), constraint teste_pk primary key (id));

insert into teste (id, valor_inteiro, valor_float, flag)
select level as id, level * 10 as valor_inteiro, level * 10.5 as valor_float, decode(mod(level, 2), 0, 'S', 'N') as flag
from dual
connect by level <= 10;
commit;

select * from all_objects where object_name = 'TESTE';
select * from user_objects where object_name = 'TESTE';

alter table teste2 rename to teste;
alter table teste move;

-- 30779

alter table teste drop (blabla);

alter table teste add (valor_ds_interval interval day to second);


select auditor.generate_audit_trigger('gleidson', 'teste', 'aud$teste') from dual;

exec auditor.start_audit('GLEIDSON', 'TESTE');

exec auditor.stop_audit('GLEIDSON', 'TESTE');

exec auditor.refresh_audit('GLEIDSON', 'TESTE');

select * from audit_config;

select * from teste;

alter table teste disable all triggers;
alter trigger sys.aud$30841 disable;

update teste set blabla = '1';

--truncate table audit_logs;

update teste set valor_ds_interval = numtodsinterval(10, 'SECOND') where id = 1;

update teste set flag = 'x' where id = 1;
update teste set valor_inteiro = 1 where id = 1;
update teste set valor_float = 1.1 where id = 1;
update teste set valor_inteiro = 1, flag = 'X' where id = 1;

select *
from teste t
join audit_logs l on l.table_owner = 'GLEIDSON' and l.table_name = 'TESTE' and auditor.get_data(l.row_key) = auditor.get_data(auditor.to_anydata(t.id))
;

select * from audit_logs;

select al.audit_id, al.audit_date, 
  al.table_owner, 
  al.table_name,
  auditor.get_data(al.row_key) as row_key,
  al.column_name, 
  auditor.get_data(al.old_value) as old_value,
  auditor.get_data(al.new_value) as new_value
from audit_logs al
--where auditor.get_data(al.row_key) = auditor.get_data(auditor.to_anydata(1))
;
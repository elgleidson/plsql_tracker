alter session set time_zone = '-12:0';

begin
  execute immediate 'drop table gleidson.test';
exception when others then null;
end;
/

create table gleidson.test (
  id number, 
  number_value number, 
  float_value float, 
  char_value char(1),
  varchar2_value varchar2(100),
  date_value date,
  timestamp_value timestamp,
  timestamp_tz_value timestamp with time zone,
  timestamp_ltz_value timestamp with local time zone,
  interval_ds_value interval day to second,
  interval_ym_value interval year to month,
  constraint test_pk primary key (id)
);
/

insert into gleidson.test (id) values (1);
commit;
/


select * from gleidson.test;


/***** START TRACKING CHANGES *****/
truncate table tracker_logs;

exec tracker.start_tracking(p_table_owner => 'GLEIDSON', p_table_name => 'TEST');

select * from tracker_configs;

update gleidson.test set number_value = trunc(dbms_random.value() * 1000) where id = 1;
update gleidson.test set number_value = null where id = 1;

commit;

select * from tracker_logs;

select * from tracker_log_changes;



/***** UPDATE DOES NOT CHANGE VALUE *****/
truncate table tracker_logs;

update gleidson.test set number_value = -10 where id = 1;
update gleidson.test set number_value = -10 where id = 1;

commit;

select * from tracker_logs;

select * from tracker_log_changes;




/***** CHANGES IN DATA TYPES SUPPORTED *****/
truncate table tracker_logs;

update gleidson.test set number_value = trunc(dbms_random.value() * 1000) where id = 1;
update gleidson.test set char_value = dbms_random.string('A', 1) where id = 1;
update gleidson.test set varchar2_value = dbms_random.string('A', 10) where id = 1;
update gleidson.test set date_value = sysdate where id = 1;
update gleidson.test set timestamp_value = systimestamp where id = 1;
update gleidson.test set timestamp_tz_value = current_timestamp where id = 1;
update gleidson.test set timestamp_ltz_value = localtimestamp where id = 1;
update gleidson.test set interval_ds_value = numtodsinterval(10, 'SECOND') where id = 1;
update gleidson.test set interval_ym_value = numtoyminterval(1, 'MONTH') where id = 1;

commit;


select * from tracker_logs;

select * from tracker_log_changes;


/***** ROLLBACK TRANSACTION *****/
truncate table tracker_logs;

update gleidson.test set number_value = trunc(dbms_random.value() * 1000) where id = 1;
update gleidson.test set number_value = trunc(dbms_random.value() * 1000) where id = 1;

select * from tracker_logs;

select * from tracker_log_changes;

rollback;


select * from tracker_logs;

select * from tracker_log_changes;



/***** UPDATE MORE COLUMNS AT SAME TIME *****/
truncate table tracker_logs;


update gleidson.test set 
  number_value = trunc(dbms_random.value() * 1000), 
  char_value = dbms_random.string('A', 1), 
  varchar2_value = dbms_random.string('A', 10)
where id = 1;

commit;


select * from tracker_logs;

select * from tracker_log_changes;



/***** ADD A COLUMN *****/
-- must refresh tracking otherwise changes will not tracked
truncate table tracker_logs;

alter table gleidson.test add another_value number;


update gleidson.test set another_value = trunc(dbms_random.value() * 1000) where id = 1;

commit;


select * from tracker_logs;

select * from tracker_log_changes;


exec tracker.refresh_tracking(p_table_owner => 'GLEIDSON', p_table_name => 'TEST');

update gleidson.test set another_value = -500 where id = 1;

commit;


select * from tracker_logs;

select * from tracker_log_changes;




/***** RENAME A COLUMN *****/
-- must refresh tracking otherwise changes will raise exception when tracking
-- because it invalidates the tracking trigger
truncate table tracker_logs;

alter table gleidson.test rename column another_value to other_value;


update gleidson.test set other_value = trunc(dbms_random.value() * 1000) where id = 1;

commit;


exec tracker.refresh_tracking(p_table_owner => 'GLEIDSON', p_table_name => 'TEST');


update gleidson.test set other_value = trunc(dbms_random.value() * 1000) where id = 1;

commit;


select * from tracker_logs;

select * from tracker_log_changes;




/***** EXCLUDE SOME COLUMNS FROM TRACKING *****/
truncate table tracker_logs;

exec tracker.start_tracking(p_table_owner => 'GLEIDSON', p_table_name => 'TEST', p_exclude_columns => 'char_value,varchar2_value');

select * from tracker_configs;

update gleidson.test set char_value = dbms_random.string('A', 1) where id = 1;
update gleidson.test set char_value = dbms_random.string('A', 1) where id = 1;

update gleidson.test set varchar2_value = dbms_random.string('A', 10) where id = 1;
update gleidson.test set varchar2_value = dbms_random.string('A', 10) where id = 1;

commit;

select * from tracker_logs;

select * from tracker_log_changes;



/***** STOP TRACKING CHANGES *****/
truncate table tracker_logs;

exec tracker.stop_tracking(p_table_owner => 'GLEIDSON', p_table_name => 'TEST');

select * from tracker_configs;


update gleidson.test set number_value = trunc(dbms_random.value() * 1000) where id = 1;
update gleidson.test set char_value = dbms_random.string('A', 1) where id = 1;
update gleidson.test set varchar2_value = dbms_random.string('A', 10) where id = 1;
update gleidson.test set date_value = sysdate where id = 1;
update gleidson.test set timestamp_value = systimestamp where id = 1;
update gleidson.test set timestamp_tz_value = current_timestamp where id = 1;
update gleidson.test set timestamp_ltz_value = localtimestamp where id = 1;
update gleidson.test set interval_ds_value = numtodsinterval(10, 'SECOND') where id = 1;
update gleidson.test set interval_ym_value = numtoyminterval(1, 'MONTH') where id = 1;

commit;


select * from tracker_logs;

select * from tracker_log_changes;


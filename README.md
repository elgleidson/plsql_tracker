# plsql_tracker

A simple PL/SQL change tracking tool for Oracle database.

The main idea is to use it to tracking row changes - What values (columns) have changed? What were the old values? What are the new values?

This tool generate a trigger to track this changes. Install it in the SYS schema, so nobody can disable this triggers, and be happy :)


## Usage example

Create a table and insert a row in it:

```
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
```

```
insert into gleidson.test (id) values (1);
commit;
```

```
select * from gleidson.test;
```

Now, let's start track changes:

```
exec tracker.start_tracking('GLEIDSON', 'TEST');
```

And then, update a column value to see the tracker in action:

```
update gleidson.test set number_value = 1 where id = 1;
commit;
```

Check tracking logs:

```
select * from tracker_log_changes where table_owner = 'GLEIDSON' and TABLE_NAME = 'TEST';
```

As we can see, there is a row with old value as null and new value as 1.

*The `tracker_log_changes` is a view which make easier see the changes in columns.*


Now let's update this column to another value and check the tracking logs:

```
update gleidson.test set number_value = 2 where id = 1;
commit;
```

```
select * from tracker_log_changes where table_owner = 'GLEIDSON' and TABLE_NAME = 'TEST';
```

As we can see, there is another row with old value as 1 and the new value as 2.


The tracker just track changes, not updates. So, if you update a column to the same current value, the tracker will not track this update. Let's see:

```
update gleidson.test set number_value = 2 where id = 1;
commit;
```

```
select * from tracker_log_changes where table_owner = 'GLEIDSON' and TABLE_NAME = 'TEST';
```

As said, nothing was tracked because the value has not changed.


Now, what happen when more columns are updated?

```
update gleidson.test set number_value = 10, char_value = 'S' where id = 1;
commit;
```

```
select * from tracker_log_changes where table_owner = 'GLEIDSON' and TABLE_NAME = 'TEST';
```

As we can see there are "2 new rows"*: 
- One to number_value columns with old value is 2 and new value as 10
- Another one to char_value column with old value as null and new value as S

* In the underlying table there is just 1 row tracking the update above. As said before, `tracker_log_changes` is just a view that make easier see the changes. To see details, check *nested table*.


To stop tracking changes, just call the tracker procedure `stop_tracking`:

```
exec tracker.stop_tracking('GLEIDSON', 'TEST');
```

**Important:** any change to the table - like columns added or renamed - must be follow by calling `refresh_tracking` procedure. Otherwise exception will be raised (in the case of renames) or the changes will not be tracked (in the case of columns added):

```
exec tracker.refresh_tracking('GLEIDSON', 'TEST');
```